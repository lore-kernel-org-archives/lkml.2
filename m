Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610Ab0HMNbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:31:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49465 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0HMNbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fJeGWEJbGaLlZF3i9ldIav5uULj/mO2i7kMZvwncKYlFgskGUtYSEI4Ox3KNVpvPlD
         XcLaehk8P/R0zvcky6riemehEMb1aoKBCI4IJlqXM1omiMl8+vAK7CC4uaKglq218ei3
         iXSlQyyoWqaQnO5MoIZ+ahOAWnKLoWNnYz16k=
MIME-Version: 1.0
In-Reply-To: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
Date: Fri, 13 Aug 2010 21:31:46 +0800
Message-ID: <AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
Subject: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with
 multiple configurations
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <mina86@mina86.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 5:31 PM, Dries Van Puymbroeck
<dries.van.puymbroeck@gmail.com> wrote:
> When a mutlifunction gadget has more than 1 configuration, Windows does not
> use its generic driver for multifunctional USB devices.

Sorry but what do you mean by the above?
As per the previous discussions, it seems that a registry entry hack
(for Vista and Windows 7) is needed.
http://msdn.microsoft.com/en-us/library/ff538059%28VS.85%29.aspx

> This commit adds an INF file that will load the required Windows driver
> as well as a short description in gadget_multi.txt

It seems to me your inf file forces the USB Generic
Parent Driver (for USB Composite Device) to load. But for which
configuration? I do not have any device to test myself. But
I tend to guess it will still be the first configuration (either
RNDIS or CDC ECM).

I did see something similar for WMCDC.
http://msdn.microsoft.com/en-us/library/ff538833%28VS.85%29.aspx
http://msdn.microsoft.com/en-us/library/ff537100%28v=VS.85%29.aspx

-- 
Xiaofan
