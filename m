Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2GNDXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:23:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57756 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab2GNDXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <web-769686321@zbackend1.aha.ru>
References: <web-769686321@zbackend1.aha.ru>
Date: Sat, 14 Jul 2012 13:23:36 +1000
Message-ID: <CAPM=9twk-qPGgFYCSRrOfqFU2mMoNtjyuT5UR2gqdEAhnMcBHw@mail.gmail.com>
Subject: Re: 3.5-rc6 fb hw inteldrmfb
From: Dave Airlie <airlied@gmail.com>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Daniel,

On Sat, Jul 14, 2012 at 12:18 PM, werner <w.landgraf@ru.ru> wrote:
> On a computer of someone else, on which today I tried to install 3.5-rc6
> (what on my computer and on an HP pavillon laptop runs without problem - on
> the laptop however needs ircpoll otherwhise don't find the harddisk), few
> seconds after start booting it sticks and don't continue longer (reboot not
> possible with Ctr-Alt-C but only pressing the reboot button), the last
> message is:   "conflicting fb hw usage inteldrmfb vs VESA VGA - removing
> generic driver"        then the cursor stops blinking, and the computer
> sticks.

wierd, are you passing a vga= to the kernel? or is grub2 going graphical?

also the dmesg from 3.4 might be good.

Dave.
