Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2FJExE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:53:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40028 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2FJExD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkwNT=U58520GpkNLtBcJVtujh=wN8-+uEXXkFJZSoByvUj7w@mail.gmail.com>
References: <CANc+2y41rDOrAijbgOAgWiTPzGeyMW+EXSxmu+zTv2ZqG=TxFA@mail.gmail.com>
	<20120525062120.GA4445@kroah.com>
	<CAHkwNTmpDTe-jOvR1t4tKo6uR-oEOMk2Sj2p_v6JsVtQCF2zEg@mail.gmail.com>
	<CANc+2y5WXX1n8Hugej-STfVra_Pjhjpb_OvT6Tf-K8=-hxaH=g@mail.gmail.com>
	<CAHkwNTnVgGt6J9gb2gZSpYra1HHPibgj+W9X_rEHjAyDnDL+Jg@mail.gmail.com>
	<CANc+2y6uTcQxjRTAfBGvBJBUNh-SEtM_0s+7DBrSr=yULws1OA@mail.gmail.com>
	<CAHkwNT=U58520GpkNLtBcJVtujh=wN8-+uEXXkFJZSoByvUj7w@mail.gmail.com>
Date: Sun, 10 Jun 2012 10:23:01 +0530
Message-ID: <CANc+2y5muGiJ6iWpO2yaCotNgwnT1GtuvKkyyNOzofJStfeBbg@mail.gmail.com>
Subject: Re: Code flow from device connection to device node in /dev creation
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: Anil Nair <anilcoll90@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 11:57 PM, Anil Nair <anilcoll90@gmail.com> wrote:
> Hi Prasanna,
>
> On Sun, May 27, 2012 at 10:19 AM, prasannatsmkumar
> <prasannatsmkumar@gmail.com> wrote:
>
>> If I open a device file (say a printer device) who determines the
>> correct driver and sends the call? How subsequent calls get processed
>> etc. Yes I know the init function will be called while the driver is
>> loaded (while running insmod driver.ko). How a open or write call
>> comes to the driver from user space? Who keeps track of the driver's
>> internal data (*dev) and sends that while calling methods in the
>> driver? I am more interested in things like that.
>
> Drivers work in kernel address space. The implementation of the USB in
> userspace is through the library libusb, i guess you have visited its
> thread in mailing list. You will require a serious reading before
> jumping into coding.
> Sorry if you have done the required reading. :).
>
> --
> Regards,
> Anil Nair

Anil,

I have understood the code flow now. Actually I was not speaking about
user space drivers but about user space applications opening the
device and communicating with it.
