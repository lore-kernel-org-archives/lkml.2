Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1ANRrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:47:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61240 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab1ANRrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:47:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=M2UCZvSVtw+6Aa2VMphaoEX5+0rCUeLUh6z106+P7scHClMiBI9M2ZPj96igum36aG
         MabYyN23hDKy/BOJoR3ldb7vZhI74G7RzA7EMTNuO0ucf4hdUwTA2yqVdz5EhmXunM/N
         cQQIgp+Eg4oRA+YqQYAVGx7Dj9BjWYGiz7gd4=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 23:17:41 +0530
Message-ID: <AANLkTi=DU3MpNd4-7a3-n2E3voPk25AtwdL93SxGcvn8@mail.gmail.com>
Subject: Size difference in Kernel Modules
From: anil joshi <anilsjoshi123@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, anil joshi <anilsjoshi123@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have compiled kernel 2.6.35 but there is huge difference in size
between 2.6.35.6-45.fc14.i686 (fedora core 14 ) and  compiled one
I am using same configuration file as fc14 uses

following details show difference in size


[Anil@localhost linux-2.6.35]$ du -h
/lib/modules/2.6.35.6-45.fc14.i686/kernel/drivers/video/backlight/lcd.ko
8.0K /lib/modules/2.6.35.6-45.fc14.i686/kernel/drivers/video/backlight/lcd.ko
[Anil@localhost linux-2.6.35]$ du -h
/lib/modules/2.6.35/kernel/drivers/video/backlight/lcd.ko
160K /lib/modules/2.6.35/kernel/drivers/video/backlight/lcd.ko
[Anil@localhost linux-2.6.35]$


62M /lib/modules/2.6.35.6-45.fc14.i686/

587M /lib/modules/2.6.35/
