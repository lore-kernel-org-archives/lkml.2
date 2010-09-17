Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0IQPHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:07:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59053 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0IQPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Zxewjv7YSUMZlx9Lq8jQqbWhwE7NNmkygr67U4M80grcWgbHgTy7MVdqCMKndV1Teb
         d8EvfXWxSZPsnM+T9FSDIvp2d57n13l0tziR6iHUpr2SvZ6UYjo19nN1ULsf92VHNj9L
         S+C62fmIulO3HBaTws44HAj+moxXeQm4ND42A=
MIME-Version: 1.0
Date: Fri, 17 Sep 2010 17:07:20 +0200
Message-ID: <AANLkTi=pxciY2jJePYPDzaRjsyGo3pQTeip0AJSqrzzh@mail.gmail.com>
Subject: 2.6.35.4+current stable queue: hangs at boot, bisected
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: shijie8@gmail.com, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    Linux kernel 2.6.35.4+patches in stable-queue hangs at boot, right
after selecting it on grub. The cursor blinks and there's no output
whatsoever. I've bisected the problem to the patch
"percpu-fix-a-memory-leak-in-pcpu_extend_area_map.patch". Without it
and applying all the others, the kernel works again. If you need more
info, let me know.

-- 
Giangiacomo
