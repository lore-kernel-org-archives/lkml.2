Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab1KCMPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:15:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53956 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086Ab1KCMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:14:58 -0400
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 14:14:56 +0200
Message-ID: <CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com>
Subject: Simultaneous cat and external keyboard input causing kernel panic
From: Timo Jyrinki <timo.jyrinki@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encountered a kernel panic with the 3.1.0 kernel on a Dell Latitude
E6410 while inputting simultaneously from the integrated keyboard with
a cat and from the external keyboard myself. I was trying to type my
password with the external keyboard (pw dialog already visible), but I
noticed that the computer didn't seem responsive to my typing. Then
suddenly the cat shifted his position and there was a kernel panic
involving input handling. I'm now using i8042.nokbd kernel parameter
as a workaround, something I've found useful also earlier.

I wonder if anyone else is experiencing similar problems? This didn't
seem to happen with 3.0, which was the first kernel version I used on
this E6410. Although it has to be noted that the internal keyboard
input was not yet as heavy either at that time. Please test if you can
reproduce the problem.

Photos of the panic at http://people.debian.org/~timo/kernelpaniccat/.
The first one was taken about ten seconds after the panic and shows
the original cat positioning. The two other ones show alternative
possible positions together with more of the panic text. There is also
one photo showing the pre-crash setup, which I happened to take
without anticipating a panic. The similar but black input weight was
not in use.

The kernel was tainted because the Intel "mei" module from staging was
loaded. The kernel used was the final 3.1 from the ubuntu mainline ppa
archives for amd64.

Thank you,

Timo Jyrinki
