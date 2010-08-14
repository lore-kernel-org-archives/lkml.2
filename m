Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab0HNIjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:39:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32931 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab0HNIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type;
        b=cvHtrWPZ4SBUNpwjg1CexL8jF6vUoULFIO3TbEtgjblDKpDC+hKdAxoUKd5/bOL0sm
         n5if1gqsdz2bFS8PibzumRU2ogkkoCgrMyDn5mRpKduH8aaRF196viu+F3vBBqLhGWIG
         s4v7UoBt05TP4/lWI8SlgA6qgVQsYEL7qUNYU=
From: Michal Nazarewicz <mina86@mina86.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        =?utf-8?Q?Micha?= =?utf-8?Q?=C5=82?= Nazarewicz 
	<m.nazarewicz@samsung.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
	<AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
	<87sk2i45es.fsf@erwin.mina86.com>
	<AANLkTin_o36qmavka+aJaDOBpNRGc=xxKdPdtWWUcVG8@mail.gmail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sat, 14 Aug 2010 10:39:06 +0200
In-Reply-To: <AANLkTin_o36qmavka+aJaDOBpNRGc=xxKdPdtWWUcVG8@mail.gmail.com>
	(Xiaofan Chen's message of "Sat, 14 Aug 2010 09:27:57 +0800")
Message-ID: <87r5i1h9lh.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaofan Chen <xiaofanc@gmail.com> writes:
> Basically I am just wondering if the following statement is true or not.

> On Fri, Aug 13, 2010 at 5:31 PM, Dries Van Puymbroeck wrote:
>> When a mutlifunction gadget has more than 1 configuration, Windows does not
>> use its generic driver for multifunction USB devices.

> I am thinking the inf file is not necessary.
> "When the system detects that a USB device is composite, it loads the
> USB common class generic parent driver (usbccgp.sys)."
> http://msdn.microsoft.com/en-us/library/ff538059%28VS.85%29.aspx

<http://msdn.microsoft.com/en-us/library/ff537109(v=VS.85).aspx>
specifies that for a device to be identified as composite it (among
other things) "must have a single configuration".  The page has also
a passage which seems to indicate that the INF is needed:

> If you want the generic parent driver to manage your device, but your
> device does not have the characteristics necessary to ensure that the
> system will generate a compatible ID of USB\COMPOSITE, you will have
> to provide an INF file that loads the generic parent driver.

Selecting of the configuration is also mentioned as a requirement, and
the next paragraph points to a web page you've cited:

> If your composite device has multiple configurations, the INF file you
> provide must specify which configuration the generic parent should use
> in the registry. The necessary registry keys are described in
> Selecting the Configuration for a Composite USB Device.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
