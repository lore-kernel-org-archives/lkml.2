Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2GDSe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:34:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62295 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2GDSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:34:54 -0400
MIME-Version: 1.0
From: Dharam Kumar <dharam.kumar.gupta@gmail.com>
Date: Thu, 5 Jul 2012 00:04:32 +0530
Message-ID: <CAOt5+pSrpsyvuyyT=kQj0k6u5m+KnJTH_+Q7hLhkkW0pNFSqpA@mail.gmail.com>
Subject: Info on Remote controller keys like upper-right, upper-left ,
 lower-right, lower-left ,sub-picture etc.
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been working on a MHL( www.mhltech.org  ) transmitter driver
which needs to receive/handle incoming Remote control keys.

The specification tells me that other than normal keys[up,down,left,
right etc.] there are certain remote control keys like Upper-right,
Upper-left, Lower-right, Lower-left, Sub-picture etc.

While creating a key map in the driver, I tried to find whether these
keys has been defined in <linux/input.h> ,but I could not find such
key definitions
in the header file.

Please note that, although the Specs do define these Remote Controller
keys, the driver will have the choice
to support the key depending on the key-map.

Something like this:
/* Key Map for the driver */
  ....
 { KEY_UP, <supported> },
 { KEY_DOWN, <supported>},
 {KEY_UPPERRIGHT, <supported>},      /* No  definition for
KEY_UPPERRIGHT in input.h  */
 {KEY_UPPERLEFT, <not-supported>},  /* No definition for KEY_UPPERLEFT
in input.h, although this key is not supported by driver */
....


In other mailing lists[linux-input], it has been suggested that these
keys are similar to Joystick keys.
I've looked into drivers/input/joystick/analog.c file, but could not
find any buttons/pads which are similar to the above one[Am I missing
something here??]

any pointers??

Regards,
Dharam
