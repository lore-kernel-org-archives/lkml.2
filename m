Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482Ab2FDMoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:44:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2FDMoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:44:01 -0400
Message-ID: <1338813830.28282.44.camel@twins>
Subject: Re: [PATCH] x86, smp: Fix topology checks on AMD MCM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Mon, 04 Jun 2012 14:43:50 +0200
In-Reply-To: <1338813717-28112-1-git-send-email-bp@amd64.org>
References: <20120529174804.GC8263@alberich.amd.com>
	 <1338813717-28112-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 14:41 +0200, Borislav Petkov wrote:
> The warning below triggers on AMD MCM packages because physical
> package
> IDs on the cores of a _physical_ socket are the same. I.e., this field
> says which CPUs belong to the same physical package.
> 
Thanks!
