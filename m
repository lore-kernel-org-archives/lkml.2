Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1CUOoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:44:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49967 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1CUOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=mDmneKuzXSGXBCfl9XmSnZ4zKgC5XitFz8/chPLKNNdtYkrsfIccJBot950iC8jEol
         8BQYbUrJYfrzGq9tF/HXJc8DIopDGWFf4+IPRQxi9UpMVdo+yT75ibtYuvfGs1wZAJCr
         1NeIG52SUcYyqJtaCvfC9qHvLmjIOgw6f9ZgU=
MIME-Version: 1.0
From: nidhi mittal hada <nidhimittal19@gmail.com>
Date: Mon, 21 Mar 2011 20:13:34 +0530
Message-ID: <AANLkTimwa4hvTzX+S1E08rwUKYrGB76GiZoE5LhHjGyu@mail.gmail.com>
Subject: usb-serial gadget -- windows xp not working
To: linux-usb@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all
I tried using g_serial driver for using my BeagleBoard (BB)  as usb
serial gadget to connect it to windows xp host.
using this link
http://www.mjmwired.net/kernel/Documentation/usb/gadget_serial.txt

The command
modprobe g_serial executed properly  on BB (gadget) and It gets
identified successfully on Linus host(ubuntu) when connected through
usb wire.

But
when the gadget connected to Windows XP .
Host XP identifies a new hardware in device manager ...But the step of
installing the .inf file obtained from
http://www.mjmwired.net/kernel/Documentation/usb/linux-cdc-acm.inf
does not succeed !!!

As i found after googling --  i changed the product ID Vendor ID in
.inf file ..as found for my gadget.
But the problem persists.!!!

Pl help .

Thanks
Nidhi








-- 
Thanks & Regards
Nidhi Mittal Hada

http://nidhi-searchingmyself.blogspot.com/
