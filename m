Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1IRRer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:34:47 -0400
Received: from lucidpixels.com ([72.73.18.11]:37293 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab1IRReq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:34:46 -0400
Date: Sun, 18 Sep 2011 13:34:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 3.1-rc4: LinkUSBi - digitemp/sensors not working : Error 10: Read
 COM Failed
Message-ID: <alpine.DEB.2.02.1109181320500.7278@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two LinkUSBi wireless temperature sensors (masters) and both work
fine in Windows 7, I got them both to work in Linux once but I did not
record how I did it-- does anyone know why the following happens?

You are only supposed to use digitemp_ds9097u but including all just
incase someone mentions trying the other two :)

--

Others:
http://tech.akom.net/archives/60-Fixing-digitemp-with-LinkUSB-on-kernels-after-2.6.32-24.html

(Also tried his patch)

# ./digitemp_DS9097U -s /dev/ttyUSB0 -w
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
Error 5: DS2480B Adapter Not Detected
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed

More reports:
https://groups.google.com/forum/#!msg/digitemp/L3weoRnJqvA/IhadSexe0pkJ

--

./digitemp_DS2490 -a -w/dev/ttyUSB1
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
USB ERROR: owAcquire called with invalid port string

./digitemp_DS9097 -a -w/dev/ttyUSB1
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
./digitemp_DS9097U -a -w/dev/ttyUSB1
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
Error 5: DS2480B Adapter Not Detected
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed
Error 10: Read COM Failed

--

./digitemp_DS2490 -a -w -sUSB
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
USB ERROR: Attempted to select invalid port number

./digitemp_DS9097 -a -w -sUSB
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
Error, serial port 'USB' does not exists!
./digitemp_DS9097U -a -w -sUSB
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
Error, serial port 'USB' does not exists!

--

#  digitemp_DS2490 -s /dev/ttyUSB0 -i
DigiTemp v3.5.0 Copyright 1996-2007 by Brian C. Lane
GNU Public License v2.0 - http://www.digitemp.com
USB ERROR: owAcquire called with invalid port string

--

Any variation/etc fails.

--


Justin.


