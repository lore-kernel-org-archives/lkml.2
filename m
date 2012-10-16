Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2JPXW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:22:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39813 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2JPXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:22:55 -0400
MIME-Version: 1.0
X-Originating-IP: [188.230.80.151]
Date: Wed, 17 Oct 2012 02:22:48 +0300
Message-ID: <CAEswnZjKo=JnGWTV1iS9JNy9kZf1LCQ2xVTNj6oJ0H0BbRA57Q@mail.gmail.com>
Subject: The screen goes white on blanking in 3.7-rc1
From: Yaroslav Fedevych <yaroslav@fedevych.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried to use the framebuffer text console with the latest (as
of yesterday) kernel 3.7-rc1.
I have a Thinkpad Edge 13, model 0197, with onboard Radeon HD3200. So
far, so good, except
that instead of actually blanking the screen and powering it down, the
screen goes blank momentarily
and then goes back on, but fully white. dmesg is totally silent on this subject.

Under X, there's no problem. The screen goes black when power saving,
not white, and is powered
down properly.

When I close the laptop's lid, the screen is blanked and backlight
turned off just as it is
supposed to be.

I'm pretty sure the problem wasn't there in 3.5 kernels, and can't really say
about 3.6 series.

I'm wondering if that's kernel or my hands, but the kernel 3.2 worked
fine (I'm on Debian Sid and they
ship it).

I haven't tried to bisect this, either, given a few deadlines I'm facing.
