Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0JNQlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:41:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38834 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0JNQlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EWeA27bA7LSWoQf/6tziUVcqdVKkigXCX/chUyOWM2tbKj/QVRiDfFxH8DWvVKW+Z/
         apkZ1jKbzfj1DNRrxG0SdPNLR41VX8vKCyIhIp/Y5JQVYOz/MNdsNLB4w+k4KVu2kHBO
         K5b6GD3lgGFgYiQgDlp5d8fg0qqsB14oSOF2s=
MIME-Version: 1.0
Date: Thu, 14 Oct 2010 18:40:58 +0200
Message-ID: <AANLkTi=kQGo03u1FoWt_2MF_CocwrBxmVnLSC5u67Vr7@mail.gmail.com>
Subject: BUG_ON or Oops NULL deref ?
From: Metuki Sabhe <sabhe.metuki@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realize this may start a flamewar, but I would like to have your inputs here:

Do we BUG_ON on NULL pointers before dereferencing them, or even more
idiotically, explicitly check the pointers and return an error if they
are invalid, or, can we sanely assume a NULL deref would Oops.

Yes, we had exploits, but can't we trust mmap_min_addr now ?
