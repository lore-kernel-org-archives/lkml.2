Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1FLKsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 06:48:09 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49040 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1FLKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 06:48:05 -0400
MIME-Version: 1.0
X-Originating-IP: [178.212.100.195]
Date: Sun, 12 Jun 2011 13:48:02 +0300
Message-ID: <BANLkTikzmp0BLefUPiiHZpK+48MYPeRE3A@mail.gmail.com>
Subject: drm-radeon failures on R600: patches still don't work
From: Jaroslaw Fedewicz <jafd@netstyle.com.ua>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There was a recent thread as found on
https://lkml.org/lkml/2011/6/8/17, started by Markus Trippelsdorf:

> The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
> (RS780). The mouse cursor is just a black block suddenly and I see an
> endless stream of:
> radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid format 26
> [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !

This is also true of my laptop (Thinkpad Edge 13, AMD model) which has
built-in Radeon HD3200 (RS780) inside, and the most recent kernel from
git.

Unfortunately, none of the patches proposed so far worked. The patch
by Markus (https://lkml.org/lkml/2011/6/8/19) did work in the sense
that X actually started up, but all graphics were very sluggish
including mouse movements, to the point of unability to do anything
remotely useful on that machine, and a patch proposed by Dave Airlie
(https://lkml.org/lkml/2011/6/8/117) didn't apply - it comes out the
line it added was already in the code.

I'm not a kernel hacker by any means, so sorry if I understood
anything wrong; if I need to supply any additional information, I'll
be glad to.

Also, sorry for not continuing that thread; I have just subscribed so
I can't "reply" to it.
