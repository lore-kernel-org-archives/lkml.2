Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1BWAjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:39:33 -0500
Received: from fifo99.com ([67.223.236.141]:56083 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1BWAjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:39:32 -0500
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Dima Zavin <dima@android.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <8ya62sbli3z.fsf@huya.qualcomm.com>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	 <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	 <4D5DC289.1090004@codeaurora.org>
	 <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
	 <1298419839.17118.5.camel@m0nster>  <8ya62sbli3z.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 16:39:27 -0800
Message-ID: <1298421567.17118.8.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 16:17 -0800, David Brown wrote:
> On Tue, Feb 22 2011, Daniel Walker wrote:
> 
> > On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:
> >
> >> What is the problem leaving it under arch/arm/mach-msm?
> >
> > Because it's a driver.
> 
> There are a lot of other drivers currently under various arch
> subsystems.  I'm not sure if a driver that is specific to only one arch
> has a strong reason to be elsewhere in the kernel.  If there was a
> possibility of there being other devices that used SSBI, it might make
> sense to put it elsewhere.  But, as far as I know, this device is only
> found on MSM chips.

There are lots of arch specific drivers under drivers/ . In fact I'm
sure there are more arch specific drivers under drivers/ than anyplace
else. That's how we organize things in Linux.

> It seems kind of unusual to create an entirely new directory under
> drivers to hold what will only ever be a single driver.

Then put it under another directory.

Daniel

