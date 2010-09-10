Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0IJSrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:47:53 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:38882 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0IJSrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:52 -0400
Date: Fri, 10 Sep 2010 11:47:51 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: after closing the lid and reopening it the screen remains blank
Message-ID: <20100910184751.GA17794@hexapodia.org>
References: <20100909224117.GA30000@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909224117.GA30000@gamma.logic.tuwien.ac.at>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 07:41:17AM +0900, Norbert Preining wrote:
> running: 2.6.36-rc3+ (from git) on Integrated Graphics Chipset: Intel(R) GM45
> (Sony Vaio Z11)
> Debian/unstable, so xserver 1.7.7, intel driver: 2.12.0
> 
> since some recent kernel I have the following problem: When closing the
> lid on power, so the machine does not suspend, the backlight is properly
> turned off.
> 
> But when I open the lid again the backlight goes on, but there is nothing
> to see: No screensaver, no activity, nothing. Switching to Console in
> blind didn't work either.
> 
> The machine is still responsible (Sysrq, but also CapsLock), and 
> killing the X process with Ctrl-Alt-Backspace gets me back a working
> X.
> 
> I am quite sure that it *was* working in former time, but cannot
> pinpoint eaxactely when the problems started.
> 
> If you need any further information or testing, please let me know.
> But it will take some time until I am back somewhere where I can
> ssh into my machine (or try if I can ssh into).

FWIW, 2.6.36-rc3-00396-gbe6200a suspend-to-ram works for me on GM45
(Dell E4300).  I am running Ubuntu with xorg-edgers from a few months
ago:

xserver-xorg-core 2:1.6.5+git20091107+server-1.6-branch.2dbcb06a-0ubuntu0sarvatt~karmic
xserver-xorg-video-intel 2:2.11.0+git20100415.c374c94e-0ubuntu0sarvatt~karmic

There are several regression fixes pulled after 2.6.36-rc3 in merge
commit 4eab8a5717f5, can you try current linux-2.6.git ?

If it still fails, please post
 - lspci -vvv
 - /var/log/Xorg.0.log from after the failure
 - dmesg

-andy
