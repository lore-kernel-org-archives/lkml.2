Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0LQOdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab0LQOdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:33:50 -0500
Date: Fri, 17 Dec 2010 15:33:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org,
        tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86-32: Make sure we can map all of lowmem if
 we need to
Message-ID: <20101217143348.GA8104@redhat.com>
References: <4D0AD3ED.8070607@kernel.org>
 <tip-147dd5610c8d1bacb88a6c1dfdaceaf257946ed0@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-147dd5610c8d1bacb88a6c1dfdaceaf257946ed0@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 03:19:03AM +0000, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  147dd5610c8d1bacb88a6c1dfdaceaf257946ed0
> Gitweb:     http://git.kernel.org/tip/147dd5610c8d1bacb88a6c1dfdaceaf257946ed0
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Thu, 16 Dec 2010 19:11:09 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 16 Dec 2010 19:11:09 -0800
> 
> x86-32: Make sure we can map all of lowmem if we need to
> 
> A relocatable kernel can be anywhere in lowmem -- and in the case of a
> kdump kernel, is likely to be fairly high.  Since the early page
> tables map everything from address zero up we need to make sure we
> allocate enough brk that we can map all of lowmem if we need to.
> 
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>

Fix confirmed, thanks

Stanislaw
