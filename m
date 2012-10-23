Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2JWMhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:37:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:41604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2JWMhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:37:19 -0400
Message-ID: <1350995825.13456.16.camel@twins>
Subject: Re: [PATCH 08/34] perf, x86: Support Haswell v4 LBR format
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 14:37:05 +0200
In-Reply-To: <1350602382-12771-9-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-9-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> Haswell has two additional LBR from flags for TSX: intx and abort, implemented
> as a new v4 version of the PEBS record.

s/PEBS record/LBR format/ I presume ;-)
