Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab1CRQ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:58:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab1CRQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:58:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Fri, 18 Mar 2011 17:57:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103181718.08502.arnd@arndb.de> <4D83885C.3050402@cam.ac.uk>
In-Reply-To: <4D83885C.3050402@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181757.58218.arnd@arndb.de>
X-Provags-ID: V02:K0:nzymnz4/PDeCiyx8lfxrQEPxGqTk+d5QfaVUwACRJyX
 pTNS0KkA/mUmp+AdTBNTJFySuWH87Mz5cQBK75tT2gHKl2EdER
 FFFVl7dtbM1gBARomkX1eERZqUkAYbTlDL1MSSSW99ggF/wK0H
 HQ9lWT+SstVYnjV6inQch74zrpVqpyGnuPmCEys/cDR3uSQR/g
 Hj8XPSAbx6yMv85e1ZxXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Jonathan Cameron wrote:
> > I guess if it's always in${i}-in${i+1}, it's still not too hard.
> I think they have been so far, but doubt this is universal.
> How about having a diff type and just having a pair of indices in the
> channel structure?  Actually may need a third for x^2+y^2+z^2 devices.
> (iirc there are parts that do x^2+y^2 despite also having a z channel)
> ...

If two identifiers are common, that would probably be fine.

If you have a x^2+y^2+z^2 device, it might be easier to call that
a different type with a fixed name, as long as there is a small
number of combinations.

	Arnd
