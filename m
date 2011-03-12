Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1CLUXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:23:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1CLUXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FHMHpHm9PVGqORyq1qY0FOldblVJMd5TCKTNv+HgpQm/Y4SbGhJ9y+xoGc05CWIMJa
         vGh6vQz0K/Udkh8apka04sh+G2YVJR7xiPIJaMEz8UdP5xM9L4mw/Ub38BPhcEwAv+jm
         4dbhsFjx5ZpoHBawNX+w9NhUrdygEquISmIj0=
MIME-Version: 1.0
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Date: Sat, 12 Mar 2011 23:23:06 +0300
X-Google-Sender-Auth: 33XK7DNd5RoHVTieFznHhMg25G8
Message-ID: <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
Subject: Re: [PATCH 00/20] world-writable files in sysfs and debugfs
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, rtc-linux@googlegroups.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Vasiliy Kulikov (20):
>  mach-ux500: mbox-db5500: world-writable sysfs fifo file
>  leds: lp5521: world-writable sysfs engine* files
>  leds: lp5523: world-writable engine* sysfs files
>  misc: ep93xx_pwm: world-writable sysfs files
>  rtc: rtc-ds1511: world-writable sysfs nvram file
>  scsi: aic94xx: world-writable sysfs update_bios file
>  scsi: iscsi: world-writable sysfs priv_sess file

These are still not merged :(
