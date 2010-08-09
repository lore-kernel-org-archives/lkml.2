Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0HIXw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:52:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47609 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0HIXw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VAfZqCXqGR5ZnDk2qgLVAtKVV2YvI5zECLe5bXcKDW8awCyzPoT6pqNVBKDWJBgVij
         McUZahFQkaubCg+yKNDbbR1VQAFdczZmCy/lnO8I8fSYGReraE+0ec9BuwwG/o5ySUmo
         GJWPNXx4KBrCN0vlzpgfCGMB8absZDxn60myg=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 9 Aug 2010 19:52:35 -0400
Message-ID: <AANLkTikjeQ=b7c85R0-yVzSOiMKWbWksnBRiz0wmOaN2@mail.gmail.com>
Subject: gpio-addr-flash warnings on x86/highmem (Re: i386 allmodconfig,
 current mainline)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 19:43, Andrew Morton wrote:
> Guys.  What's goin' on out there?
>
> drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
> drivers/mtd/maps/gpio-addr-flash.c:212: warning: cast to pointer from integer of different size
> drivers/mtd/maps/gpio-addr-flash.c:224: warning: cast to pointer from integer of different size

i did get a bug report about this in the past, but honestly i havent
gotten around to fixing the issues.  it's been low priority as my
understanding is that the warning shows up in configurations where the
driver isnt realistically usable.  not making excuses, just laying out
the reality of things.
-mike
