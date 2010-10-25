Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0JYVbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:31:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63329 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab0JYVbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P69KzuBAT2DPqPH/67BAxwEqMmngstmvugFacqAvLj1/xA05NdlGpiy138Rhdn3fYX
         b7HTgYNy1uFu1GsO9Kejv5M5+1gzcDk+pzMEb2KmDD0r5cvXIA9x7f+rrRmKXZKs1ktP
         hkoqX+d1mSRKdfKARBJ53kDufwPufdTt+A2w0=
MIME-Version: 1.0
In-Reply-To: <4CC5F5F5.3060503@teksavvy.com>
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
	<4CC24186.1040001@teksavvy.com>
	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>
	<4CC2FD0A.9090409@teksavvy.com>
	<AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
	<4CC303FD.1000802@teksavvy.com>
	<AANLkTin9wiBZjkeKxYKnJaSA1vxs8ELGTWYVMM1DfYKu@mail.gmail.com>
	<AANLkTikzPgq0VG1V_hZsw78i2pYMxzrPJM3dFUyGeaU1@mail.gmail.com>
	<4CC5F5F5.3060503@teksavvy.com>
Date: Mon, 25 Oct 2010 22:31:02 +0100
Message-ID: <AANLkTi=pr=fWe8eN=KQ2j3NDwZ061kq-xw5648RSwnPZ@mail.gmail.com>
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise,

I already tried that and it broke the RAID. Instead I shrunk the "Used
Dev Size" of each RAID member, like so (mdadm -E dev):

Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
Used Dev Size : 3900702720 (1860.00 GiB 1997.16 GB)

I hope that should be OK. Thanks for all the info.

// Mathias


On 25 October 2010 22:26, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-10-24 08:52 AM, Mathias Burén wrote:
>>
>> My question is, is it safe for me to stop md0, delete all 4 partitions
>> that make up md0, recreate them at the same starting sector, but
>> ending 2GB from the last sector? Is this safe, will I lose any data?
>> Just in case I've backuped the MBR (first 512 bytes) of each HDD that
>> has the partition.
>
> ..
>
> Dunno.  I'm no RAID expert.  :)
>
