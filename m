Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2EYNbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:31:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2EYNbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10bzpJ1vEX9SqddV2qr9AuNY-fgZN444S-pYNM21ByBOA@mail.gmail.com>
References: <20120426001529.GA14006@kroah.com>
	<Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
	<20120426151242.GA14774@kroah.com>
	<CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
	<20120524215249.GA17936@kroah.com>
	<CAAJw_ZtaeAV2nZU7LcyngJTN15YVn+8y2dMPxtBqTGn750Tjdg@mail.gmail.com>
	<20120525060124.GA18035@kroah.com>
	<CAAJw_Ztke1NqY6Jm2fqyPOWzeVAqK=pKv=6bPhhdGaNVHaHM+g@mail.gmail.com>
	<20120525071643.GA9105@kroah.com>
	<CAPXgP10bzpJ1vEX9SqddV2qr9AuNY-fgZN444S-pYNM21ByBOA@mail.gmail.com>
Date: Fri, 25 May 2012 21:31:42 +0800
Message-ID: <CAAJw_ZuySesFhEwZBHBXM4mkFQONHLuAQ5oKcbvcVkUDsBzYcQ@mail.gmail.com>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 5:01 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Fri, May 25, 2012 at 9:16 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, May 25, 2012 at 03:06:33PM +0800, Jeff Chua wrote:
>
>>> >> VMware USB Arbitration Service Version 8.4.19
>>> >> USB: Unable to open "/proc/bus/usb/devices" (No such file or directory).
>
> I think vmware tries to open the usual /dev/bus/usb/ nodes directly
> after it has tried the deprecated /proc nodes.
>
> Udev would create the /dev/bus/ nodes.
>
> Or the kernel would create them itself if:
>  CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
> is used.
>
>> Use /dev/usb/ device nodes instead.  If you have a distro that has static
>> device nodes, just add them to the package that has those nodes, and you
>> should be fine.  That will bring you into the mid 2000's as far as
>> device nodes go, I'm amazed that this hasn't been noticed before now.
>
> Many distros have disabled the USB_DEVICEFS option and there are
> usually no reports about problems any more.
>
> But I guess the number of systems that want to run USB devices, and
> pass them along to virtualization, but have an unmanaged static /dev
> are close to one user these days. :)

Yep, it's just me (the one), I guess. Configured kernel as suggested,
and it's all working now.

Sorry, as for the distro, it's just bare minimum...but works wonderfully well.

Thanks again for all your help!

Jeff
