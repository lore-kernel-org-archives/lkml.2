Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2DPGxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:53:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64015 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2DPGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:53:00 -0400
Date: Mon, 16 Apr 2012 08:52:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd: Re-enable CPU topology extensions in case BIOS
 has disabled it
Message-ID: <20120416065249.GA5292@gmail.com>
References: <20120411152640.GC4794@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411152640.GC4794@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> 
> For detection of thread siblings we are relying on the topology
> extension CPUID leafs. Thus we have to re-enable it in case BIOS tries
> to hide the correpsonding CPUID feature flag.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

This changelog is missing some key information:

 - how did you find the bug - did you see some actual badness?

 - what practical effect (if any) did you see from this patch?

 - what practical effect (if any) do you expect others to see from this patch?

This kind of information helps us prioritize bugfixes and helps 
us determine whether a fix requires a -stable backport.

Thanks,

    Ingo
