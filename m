Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0HYJ7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:59:42 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:38917 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab0HYJ7j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:59:39 -0400
From: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>
To: "cheiny@synaptics.com" <cheiny@synaptics.com>,
        "axiong@synaptics.com" <axiong@synaptics.com>,
        "wmanson@synaptics.com" <wmanson@synaptics.com>,
        "j.de.gram@gmail.com" <j.de.gram@gmail.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Pradeepkumar Kumar SUJUAR <pradeep.kumar.sujuar@stericsson.com>,
        Sundar R IYER <sundar.iyer@stericsson.com>
Date: Wed, 25 Aug 2010 11:29:39 +0200
Subject: Re: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
Thread-Topic: Re: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen
 Driver
Thread-Index: ActEOAqhc3a2M+sISua645Q6PgSeCg==
Message-ID: <81C3A93C17462B4BBD7E272753C1057916DE5281A0@EXDCVYMBSTM005.EQ1STM.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

Some generic review comments for this patch

1. Normally, defconfig should be a separate patch. You need not
post the entire defconfig, but only the changes to the Makefiles and
the Kconfig files.

2. All RMI specific files can be moved to a separate driver folder
in input/ like drivers/input/rmi/*.

3. Lots of Hungarian notation in the code. Please refer this snippet.
 
>------------------------------------
>CODE CONTAINS HUNGARIAN NOTATION
>
>Some coding guidlines at some companies require that you type the name 
>of your variables using the infamous hungarian notation:
>http://en.wikipedia.org/wiki/Hungarian_notation
>
>We have an internal coding guideline that touches on the
>subject:
>http://swadvice.lud.stericsson.com/guideline.aspx?nr=57&ver=latest
>
>According to the Linux kernel inventor Linus Torvalds in his document 
>Documentation/CodingStyle in the Linux kernel:
>
>"Encoding the type of a function into the name (so-called Hungarian
>notation) is brain damaged-the compiler knows the types anyway and can 
>check those, and it only confuses the programmer."
>
>Remove all instances of hungariang notation in the code please.
>Includes prefixing pointers with p_*, naming structs with s_*, enums 
>with e_*, suffixes like *32b etc etc.
>-----------------------------------
>

We are also using the Synaptics RMI4 touch pad on our U8500 platform. 
We had to make some changes to these posted drivers to make it work on 
our platform. Also, we modified the touch screen driver to be compliant 
to the kernel coding guidelines, but as a stand alone driver though.

I will soon post out an RFC for our patch which we got working on our board. 
Please do have a look and we would like you guys to incorporate these changes 
into your final patch sets as well, so that we can avoid any re-works later on 
when your patch set gets merged into the mainline kernel.


Cheers!
Naveen
