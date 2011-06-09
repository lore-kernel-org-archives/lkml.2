Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1FIIki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:40:38 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52156 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1FIIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:40:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DF088E5.5000408@cam.ac.uk>
Date: Thu, 09 Jun 2011 09:48:37 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-i2c@fluff.org>,
        gregkh@suse.de, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] staging iio: Replace kmalloc with local variable
References: <1307450354.1516.23.camel@anish-desktop>	<4DEE20E7.4020008@cam.ac.uk>	<20110607134135.GD15795@trinity.fluff.org>	<20110607160206.6cb3168d@endymion.delvare>	<BANLkTim5-ZKXtDkSQyHAJ9-iKtOPsJ917A@mail.gmail.com>	<BANLkTi=e0A2G-d+t4VF5V0gj+eNoh3KRnQ@mail.gmail.com>	<20110609102948.7a3f8d57@endymion.delvare> <BANLkTimq_5rmB+UkaxZwrOtV-ZF3+fEOgQ@mail.gmail.com>
In-Reply-To: <BANLkTimq_5rmB+UkaxZwrOtV-ZF3+fEOgQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/11 09:34, anish singh wrote:
> 
> 
> On Thu, Jun 9, 2011 at 1:59 PM, Jean Delvare <khali@linux-fr.org <mailto:khali@linux-fr.org>> wrote:
> 
>     On Thu, 9 Jun 2011 13:53:09 +0530, anish singh wrote:
>     > On Wed, Jun 8, 2011 at 10:41 AM, anish singh <anish198519851985@gmail.com <mailto:anish198519851985@gmail.com>>wrote:
>     > >  On Tue, Jun 7, 2011 at 7:32 PM, Jean Delvare <khali@linux-fr.org <mailto:khali@linux-fr.org>> wrote:
>     > >> To be clearer, it is down to the i2c BUS (adapter) driver, NOT the i2c
>     > >> device driver. So the patch is correct.
>     > >>
>     > > I think i can take Jean ack on this?If yes then Joanthan kindly apply
>     > > this patch and i think you didn't lead me in wrong way as whatever
>     > > said by you is corroborated by jean also i.e. it is I2C bus driver
>     > > responsiblity
>     > > to care about DMA.
>     > >
>     > Sorry to ping you again.Can i take your ack on this?
> 
>     Yes of course.
> 
>     Acked-by: Jean Delvare <khali@linux-fr.org <mailto:khali@linux-fr.org>>
> 
> Thanks a ton.Jonathan kindly apply it now :)
Greg, I'll send this one on to you with the set I currently have out for review.

Jonathan
