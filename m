Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1HIUmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:42:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1HIUmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:42:01 -0400
Message-ID: <4E419B6E.1030309@zytor.com>
Date: Tue, 09 Aug 2011 15:41:18 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rjw@sisk.pl, hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>
Subject: Re: [tip:x86/trampoline] x86, suspend: Merge 32- and 64-bit realmode
 wakeup code
References: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr> <tip-ababf605370b2c67cc6a37305c5fa17469a4e1f1@git.kernel.org> <20110809213440.21ec2947@mat-laptop>
In-Reply-To: <20110809213440.21ec2947@mat-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2011 02:34 PM, matthieu castet wrote:
> Note that
> https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7a3136666bc0f0419f7aaa7b1fabb4b0e0a7fb76
> should be reverted for applying the patch.
> 
> This is not a problem as the x86_32 trampoline code already does that.
> 
> Any idea when it will be merged in the mainline tree ?
> 

3.2 merge window, unless something goes wrong.

	-hpa
