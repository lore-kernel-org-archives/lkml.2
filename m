Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2JGU2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 16:28:45 -0400
Received: from smtp.getmail.no ([84.208.15.66]:64298 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2JGU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 16:28:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <op.wltgb7mg6426ze@localhost.localdomain>
References: <op.wlqe9kw36426ze@localhost.localdomain>
 <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm>
 <op.wlrdzkqh6426ze@localhost.localdomain>
 <loom.20121006T164640-362@post.gmane.org>
 <op.wlrq12q96426ze@localhost.localdomain>
 <loom.20121007T022629-736@post.gmane.org>
 <op.wlsf0fuc6426ze@localhost.localdomain>
 <CAEwFKRBk0X7vAh=Sw-imXeSLN8kBjdfWFXw0Vq2GGygS=0yPrA@mail.gmail.com>
 <op.wltgb7mg6426ze@localhost.localdomain>
Subject: Re: Minimal jitter = good desktop.
To: linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 22:28:35 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wltshxtb6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also compiled a 3.6.1 with a local shave (only components I want) + my
low jitter config and tweaks. (most notably 90hz timer, which is where
many go wrong.)
Quake 2, with software renderer, in wine, went from 15/30 fps, to 60fps
with some jitter, with full distro low-jitter kernel, to perfect on the
local shaved.

Wine seems indeed also to be extremely jitter-sensitive.

So low-jitter seems to be good, for many things. Also stopping
ubuntu-daemons was neccesary.

Peace Be With You.
