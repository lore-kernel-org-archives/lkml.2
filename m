Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab0HPTCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:02:46 -0400
Received: from smtp-out-004.synserver.de ([212.40.180.4]:1056 "HELO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755775Ab0HPTCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:02:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 11360
Date: Mon, 16 Aug 2010 21:02:41 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1: WARNING when loading ehci-hcd module
Message-ID: <20100816190241.GA6785@arch.tripp.de>
References: <20100816184515.GA3247@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100816184515.GA3247@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 02:45:15PM -0400, Nick Bowler wrote:
> After installing 2.6.36-rc1, I found a call trace in my dmesg after
> boot.  Traking it down a bit, it appears to happen when ehci-hcd is
> loaded.  The log after running 'modprobe ehci-hcd' appended to this
> mail.  This wasn't a problem in 2.6.35, but I don't have time to bisect
> right now.
> 
> Now, I see the warning about how ehci should be loaded before uhci.  I
> also see that this is apparently not a new message.  My configuration
> has uhci built-in but ehci as a module.  If this is not a supported
> configuration, probably some dependencies need to be fixed in the
> Kconfig.
> 
> Other than the trace, there seems to be no problems related to ehci.

The problem is already fixed:
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2

I guess the patch will reach mainline in the next days.
-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
