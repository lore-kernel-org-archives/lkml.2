Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab1DNHNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:13:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47636 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1DNHNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=j8HxwwMVWK4stmG1JmxjkiZnASjbbB7yf7VpSn+qrT8Me+Hx4kJ9Od/1VKnRF2oJ+6
         ycdXszinxpIU8JEQlo0MYe7rcXX18Q8+53v5vhseln4APtoR83wjt59jSzJxjMuM7Qdg
         gCKR39OElWvZd2yxd7K/db1Tk4/YRVJLFzT4E=
MIME-Version: 1.0
Date: Thu, 14 Apr 2011 09:13:47 +0200
Message-ID: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
Subject: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm writing a script to automatise some parts of my kernel compilation process.

>From those scripts I'd like to be able to call the top makefile the
same way it had been called during its last invocation.

For example, if Ido:

     $ make CC=my-gcc CFLAGS="-g -fwhatever"

I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
the last invocation so my script can call make with the same
arguments.

Is this possible ?

Thanks for any ideas
-- 
Francis
