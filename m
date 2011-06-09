Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1FIIa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:30:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1603 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1FIIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:30:23 -0400
Date: Thu, 9 Jun 2011 10:29:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Ben Dooks <ben-i2c@fluff.org>,
        gregkh@suse.de, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] staging iio: Replace kmalloc with local variable
Message-ID: <20110609102948.7a3f8d57@endymion.delvare>
In-Reply-To: <BANLkTi=e0A2G-d+t4VF5V0gj+eNoh3KRnQ@mail.gmail.com>
References: <1307450354.1516.23.camel@anish-desktop>
	<4DEE20E7.4020008@cam.ac.uk>
	<20110607134135.GD15795@trinity.fluff.org>
	<20110607160206.6cb3168d@endymion.delvare>
	<BANLkTim5-ZKXtDkSQyHAJ9-iKtOPsJ917A@mail.gmail.com>
	<BANLkTi=e0A2G-d+t4VF5V0gj+eNoh3KRnQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 13:53:09 +0530, anish singh wrote:
> On Wed, Jun 8, 2011 at 10:41 AM, anish singh <anish198519851985@gmail.com>wrote:
> >  On Tue, Jun 7, 2011 at 7:32 PM, Jean Delvare <khali@linux-fr.org> wrote:
> >> To be clearer, it is down to the i2c BUS (adapter) driver, NOT the i2c
> >> device driver. So the patch is correct.
> >>
> > I think i can take Jean ack on this?If yes then Joanthan kindly apply
> > this patch and i think you didn't lead me in wrong way as whatever
> > said by you is corroborated by jean also i.e. it is I2C bus driver
> > responsiblity
> > to care about DMA.
> >
> Sorry to ping you again.Can i take your ack on this?

Yes of course.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
