Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2HFXk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:40:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52488 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab2HFXk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:40:27 -0400
Message-ID: <50205592.1030205@gmail.com>
Date: Tue, 07 Aug 2012 03:38:58 +0400
From: Max Filippov <jcmvbkbc@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@tensilica.com>,
        Kirill Krinkin <kirill.krinkin@gmail.com>
Subject: xtensa port maintenance
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

AFAIK xtensa linux port is currently in bad shape: it doesn't work in the
mainline, it fails to build in the linux-next. The latest working kernels for
xtensa are 2.6.29...31 trees hosted at the git.linux-xtensa.org.

I have a goal to make xtensa arch in the linux mainline usable.
Currently I have a number of patches on top of Linus' tree that allow to build
working allnoconfig, defconfig and allmodconfig kernels for ISS machine with
dc232b and fsf core variants [1]. For the next several weeks I'm planning to
forward-port patches accumulated in linux-xtensa.org git trees and make the
resulting kernels rock-solid. I'd like to restore xtensa participation in the
linux-next. Further (currently undetailed) plans are to bring modern Linux
features to the xtensa port, e.g. device trees.

I have a couple of questions regarding the path of xtensa-specific patches
upstream:
    - which git tree should they be targeted for? Should I set up a tree for
      pull requests, or will patches be picked up into some existing tree?
      (Looks like Linus' tree is the right target. AFAIK previously xtensa
      patches went mostly through akpm tree).

    - which mailing lists should they go to?
      (I guess that besides linux-xtensa@linux-xtensa.org list they should go
      to linux-kernel@vger.kernel.org for general review. Anything else?)

Should you wonder what I am:
I am a member of St.Petersburg Open Source and Linux Lab [2].
My previous contributions to Linux are related to p54spi wireless driver.
I'm also a developer and maintainer of the target-xtensa QEMU port [3].


[1] https://github.com/jcmvbkbc/linux-xtensa
[2] http://osll.spb.ru
[3] http://wiki.qemu.org/Features/Xtensa

-- 
Thanks.
-- Max
