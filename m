Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925Ab0HFMpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:45:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0HFMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=KS/U6iSX2oVh6pWffxquTnqtkoFLvpPrX6UMC8AcS7hjuE54ZYjR0jc/P6BEBSKbjH
         lxaSIaaPEGyRrr9NPWv6+v/Pc4eGdv9VS7tADbPc/gSL0+bUKhfxUzPNwlJfLsx9O318
         X0yjxZ2VXvA/LqXenmHzFzjkdibgXVSk4RN40=
Message-ID: <4C5C03D5.1040108@gmail.com>
Date: Fri, 06 Aug 2010 13:45:09 +0100
From: Andrew Benton <b3nton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b3pre) Gecko/20100728 Shredder/3.2a1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: make-3.82 and built in firmware
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello World
I recently upgraded to the latest version of make, 3.82. One of the 
problems I've had with it is that I can no longer recompile my kernel 
with built in firmware enabled. If I have 
CONFIG_FIRMWARE_IN_KERNEL=y
then the build fails like so:

  IKCFG   kernel/config_data.h
  CC      kernel/configs.o
  LD      kernel/built-in.o
make[2]: *** No rule to make target `/tmp/linux-build-dir/firmware/radeon/', needed by `firmware/radeon/R100_cp.bin.gen.S'.  Stop.
make[1]: *** [firmware] Error 2
make: *** [sub-make] Error 2
andy:~/save/src/linux-2.6$ 

Please CC, I'm not subscribed

Many thanks,

Andy
