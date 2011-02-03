Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1BCIiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:38:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1BCIiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:38:08 -0500
Message-ID: <4D4A696E.4050302@corscience.de>
Date: Thu, 03 Feb 2011 09:38:06 +0100
From: Bernhard Walle <walle@corscience.de>
Organization: Corscience GmbH & Co. KG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
References: <1296646296-31843-1-git-send-email-walle@corscience.de> <AANLkTikbXYxyUmBsPNO6mxB2x_4Qr49BQZTKrqvsiK8a@mail.gmail.com>
In-Reply-To: <AANLkTikbXYxyUmBsPNO6mxB2x_4Qr49BQZTKrqvsiK8a@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:u7IEEK2UpIVwEWZ7jn0Mz1//UYc0YBgAlZHUl3VlIRi
 lsq7GDdzTIPhq9DjzJkoxRoUSwr6VBEMrbsabfRsRQHmSn58T1
 itHlwfoQN3fZ/NLXB1vb/WxOUUAK6idTuVoyJMjdXWoJYZqnos
 ZDBlJ9LGaNPCZZTri5SPTT+idTWQPBCUVAfNrXIJlvc74+yorX
 3aQu8zdt6RWJkI/YmIctQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.02.2011 15:15, schrieb Grant Likely:
>>  static int spidev_open(struct inode *inode, struct file *filp)
>>  {
>>        struct spidev_data      *spidev;
>> @@ -543,6 +552,9 @@ static const struct file_operations spidev_fops = {
>>        .write =        spidev_write,
>>        .read =         spidev_read,
>>        .unlocked_ioctl = spidev_ioctl,
>> +#ifdef CONFIG_COMPAT
>> +       .compat_ioctl = spidev_compat_ioctl,
>> +#endif
> 
> Then the #ifdef/#endif can be dropped here which is tidier.

Ok, thanks, I resent the patch with that modification.


Regards,
Bernhard
