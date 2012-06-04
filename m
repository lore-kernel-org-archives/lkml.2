Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab2FDO4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:56:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:58392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2FDO4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:56:17 -0400
Message-ID: <1338821761.28282.55.camel@twins>
Subject: Re: [PATCH] x86, smp: Fix topology checks on AMD MCM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Mon, 04 Jun 2012 16:56:01 +0200
In-Reply-To: <20120604144850.GF15433@aftab.osrc.amd.com>
References: <20120529174804.GC8263@alberich.amd.com>
	 <1338813717-28112-1-git-send-email-bp@amd64.org>
	 <1338813830.28282.44.camel@twins>
	 <20120604133722.GB15433@aftab.osrc.amd.com>
	 <1338817117.28282.48.camel@twins>
	 <20120604144850.GF15433@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 16:48 +0200, Borislav Petkov wrote:
> This is cpuinfo_x86.booted_cores and here's how it progresses on this
> MCM box (below).


 http://marc.info/?l=linux-kernel&m=133849647709656
