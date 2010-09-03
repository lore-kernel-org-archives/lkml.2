Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0ICGeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:34:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48709 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0ICGeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RN1aV5hVzLgkh0JN9te+BbR/VTR6O6HZaWkahJJdzzDlYzXOj1oJOwzOln6HXZN9Iq
         QCki1bnqTLmUEW7SERaoemXzGsEDQdW3vMnDy1pxmlU6rjB/ARFX1YYGCDd+c96Mj6Ch
         KnTexY6+wGkDzqkBgjEZXUQRSuBbSkz/bs+vY=
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 12:04:09 +0530
Message-ID: <AANLkTimSsj5eW1Vy3g7S0XCKRcZ0fZ0jQ6_9VpjVMYcj@mail.gmail.com>
Subject: Crash on reducing the kernel mem.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 I am using MIPS processor, with 256 MB RAM. currently I am using 128
M for drivers and 128 M for Kernel. I tried to allocate more memory
for Drivers,
surprisingly I got crash when I reduced kernel memory to 110 M. My
debugging took me to USB controller, which was not reset in
bootloader.

I am not having any clue, why it didnt crash with 128 M ? How reducing
memory  for kernel bringing it up ?

Or am I going in wrong path ?

please share your views.

Thanks,
prabhu
