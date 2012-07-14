Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2GNJKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 05:10:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60923 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2GNJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 05:10:14 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAPM=9twk-qPGgFYCSRrOfqFU2mMoNtjyuT5UR2gqdEAhnMcBHw@mail.gmail.com>
References: <web-769686321@zbackend1.aha.ru>
	<CAPM=9twk-qPGgFYCSRrOfqFU2mMoNtjyuT5UR2gqdEAhnMcBHw@mail.gmail.com>
Date: Sat, 14 Jul 2012 11:10:14 +0200
Message-ID: <CAKMK7uFQREev+8nA74Gh5bgGzRVvQQFCOSwzw5w3DansYBW-OA@mail.gmail.com>
Subject: Re: 3.5-rc6 fb hw inteldrmfb
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 5:23 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Sat, Jul 14, 2012 at 12:18 PM, werner <w.landgraf@ru.ru> wrote:
>> On a computer of someone else, on which today I tried to install 3.5-rc6
>> (what on my computer and on an HP pavillon laptop runs without problem - on
>> the laptop however needs ircpoll otherwhise don't find the harddisk), few
>> seconds after start booting it sticks and don't continue longer (reboot not
>> possible with Ctr-Alt-C but only pressing the reboot button), the last
>> message is:   "conflicting fb hw usage inteldrmfb vs VESA VGA - removing
>> generic driver"        then the cursor stops blinking, and the computer
>> sticks.
>
> wierd, are you passing a vga= to the kernel? or is grub2 going graphical?
>
> also the dmesg from 3.4 might be good.

Also if you could test 3.5-rc5 that'd be interesting, just to check
whether the "removing generic driver" which is new in -rc6 is the
cause of this or whether we have a bigger problem with the i915 driver
crashing in 3.5-rc.

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
