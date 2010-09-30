Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0I3Kuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:50:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0I3Kue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <1285843077.748.32.camel@marc>
References: <4CA391B3.1030806@wol.de> <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
 <1285843077.748.32.camel@marc>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Sep 2010 12:50:18 +0200
Message-ID: <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
Subject: Re: [PATCH] Fix capi devicenames
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 12:37, Marc - A. Dahlhaus <mad@wol.de> wrote:
> Am Donnerstag, den 30.09.2010, 10:30 +0100 schrieb Alan Cox:
>> On Wed, 29 Sep 2010 21:21:23 +0200
>> "Marc - A. Dahlhaus" <mad@wol.de> wrote:
>>
>> > capi device names should get changed to what userspace expects.
>>
>> If userspace isn't following the spec (which has been the spec for many
>> years) then thats not our problem.

>> NAK. Fix udev.
>
> I don't think udev is the right place to fix this.
>
> Udev creates symlinks and is no longer able to overwrite the name
> attribute.

Right, udev has no business here. It's the kernels responsibility since a while.

If you can't rename the kernel devices right away for some reason, you
can add naming hints to the kernel, which udev and devtmpfs will
follow, and all should work.

In any case devices.txt should be fixed, it has not much to do with
the real world.

Kay
