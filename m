Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0FRIuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:50:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:55491 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0FRIuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:50:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Mirix <miromoman@gmail.com>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
Date: Thu, 17 Jun 2010 20:17:50 +0000 (UTC)
Message-ID: <loom.20100617T221709-460@post.gmane.org>
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net> <s5hy6gqvx9n.wl%tiwai@suse.de> <4BC782E5.7070900@tremplin-utc.net> <4BC9D1E9.1090705@roadrunner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 83.217.150.252 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100501 Iceweasel/3.5.9 (like Firefox/3.5.9))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a similar problem with hda-intel ALC883 since kernel 2.6.33 (problems are
identical with kernel 2.6.34). There are quick short gaps with the default
options. In turn, bdl_pos_adj=0 results in fast sound as reported here.
position_fix=1 does not fix it.

The card worked fine with previous kernels.

lspci : 

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller
(rev 03)

aplay -l :

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 6: Si3054 Modem [Si3054 Modem]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

dmesg:

[  199.222813] hda-intel: IRQ timing workaround is activated for card #0.
Suggest a bigger bdl_pos_adj.


