Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1E3OSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:18:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51359 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1E3OSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:18:40 -0400
Date: Mon, 30 May 2011 16:18:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: 2.6.39 hangs on boot
Message-ID: <20110530141841.GA20420@gere.osrc.amd.com>
References: <201105282235.24530.M4rkusXXL@web.de>
 <201105301505.57407.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105301505.57407.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:05:57PM +0200, Markus wrote:
> Hi!
> 
> The current running gentoo kernel is configured as the 2.6.38, just with 
> some patches (fbcondecor und ck1). Thats where the dmesg and cpuinfo is 
> from. (if its needed from a vanilla 2.6.38.7, please let me know) Its 
> cut where only usb/md stuff is printed...

Ok, let's try the usual suspects:

Can you apply

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=e9cdd343a5e42c43bcda01e609fa23089e026470

ontop of 2.6.39 and retest?

Also, when it hangs, does pressing a button on the keyboard wake the
machine up and continue booting?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
