Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0HMUfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:35:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0HMUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:x-face
         :face:x-url:x-pgp-fp:x-pgp:date:message-id:mime-version:content-type;
        b=hq/T4QwYQTNDwtAmCiOf6Ylpb/vtdPUOqnyAvWdNl76JZ9Sgbgp53sgHxxi3iWecp5
         f5itubschvh/i7WfLFiW1WWVF/YP6cPxMBzg2SBqJyx/cMEtT52H1Y9fRojHXC8PZH4G
         yucI/VNRUMd9xbK55CzUZU2sMrAcPlT6qBVwU=
From: Michal Nazarewicz <mina86@mina86.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        =?utf-8?Q?Micha?= =?utf-8?Q?=C5=82?= Nazarewicz 
	<m.nazarewicz@samsung.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations
In-Reply-To: <AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
	(Xiaofan Chen's message of "Fri, 13 Aug 2010 21:31:46 +0800")
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
	<AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Fri, 13 Aug 2010 22:35:39 +0200
Message-ID: <87sk2i45es.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaofan Chen <xiaofanc@gmail.com> writes:

> On Fri, Aug 13, 2010 at 5:31 PM, Dries Van Puymbroeck
> <dries.van.puymbroeck@gmail.com> wrote:
>> When a mutlifunction gadget has more than 1 configuration, Windows does not
>> use its generic driver for multifunctional USB devices.
>
> Sorry but what do you mean by the above?
> As per the previous discussions, it seems that a registry entry hack
> (for Vista and Windows 7) is needed.
> http://msdn.microsoft.com/en-us/library/ff538059%28VS.85%29.aspx
>
>> This commit adds an INF file that will load the required Windows driver
>> as well as a short description in gadget_multi.txt
>
> It seems to me your inf file forces the USB Generic
> Parent Driver (for USB Composite Device) to load. But for which
> configuration? I do not have any device to test myself. But
> I tend to guess it will still be the first configuration (either
> RNDIS or CDC ECM).

2-configuration g_multi has configuration with RNDIS as the first one so
that's pretty perfect for us.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
