Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0DMA0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 20:26:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40755 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0DMA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 20:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a8bAVHw1jdK6mKzI03wFo6H/RgMkPlbZcbWYXaCTO2v+QAOagkIVOueG08kbj60Vl7
         DlCtIaN6PtUVnSvLUwjzBuUztgbcJLhorIfsNvwrpre96c1EhT9r1BECp78HMkIzOjVK
         mONyQL1Kq9IMqT1hK7QfjnuyR5RctQsfDYYmI=
MIME-Version: 1.0
In-Reply-To: <y2l8cad0aa1004121229o894a17f0w9045882c214bd090@mail.gmail.com>
References: <577FAEEB8540FB4F9C91B6BB262576755905DC@XVS-DCFR-22.europe.corp.altran.com>
	 <x2y63386a3d1003311634l71486234n95f60e506b776948@mail.gmail.com>
	 <y2l8cad0aa1004121229o894a17f0w9045882c214bd090@mail.gmail.com>
Date: Tue, 13 Apr 2010 02:26:36 +0200
Message-ID: <t2m63386a3d1004121726nb6afdad1q2d75ebba34caefa3@mail.gmail.com>
Subject: Re: [PATCH] Arm nomadik : Vendor tool compatibility
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Lemetayer Jean Marie <jeanmarie.lemetayer@altran.com>,
       linux-arm-kernel@lists.infradead.org, dwmw2@infradead.org,
       linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/12 Jean-Michel Hautbois <jhautbois@gmail.com>:

> What king of modification would you do ?

Instead of coding the ECC layout into the driver I would move it to the
machine config in arch/arm/mach-* and pass it in as platform data
to the driver.

> Do you think it shall be queued before your submission ?

I will fix it for all users the day I have time, please queue this
as it is now.

Yours,
Linus Walleij
