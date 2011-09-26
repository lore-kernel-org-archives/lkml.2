Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1IZTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:48:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50664 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1IZTsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
Date: Mon, 26 Sep 2011 12:48:46 -0700
Message-ID: <CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: Joshua Scoggins <theoretically.x64@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arun <engineerarun@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep in mind that some AF drives will not report their actual sector
sizes. I have this issue with the WD AV-25 series. This is to provide
compatibility with older operating systems that don't support AF
drives. These are called generation 1 devices. Newer drives will
directly report their sector size as 4096 through the drive identify
data older ones will say 512. At that point you just need to do a
google search to see if it's AF or not.

-Josh


On Mon, Sep 26, 2011 at 3:15 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 26 Sep 2011 15:25:52 +0530
> Arun <engineerarun@gmail.com> wrote:
>
>> Is there any way to detect the Advanced Format hard drives with 4K
>> sector size? I understand that above kernel v. 2.6.31 it is supported.
>> But is it possible detect automatically if the drive is an AF drive
>> and how?
>
> It's in the drive identify data (see the ATA 8 specification documents)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
