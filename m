Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0KAKmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:42:54 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:40527 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab0KAKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:42:52 -0400
Subject: Re: sysfs and power management
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Greg KH <gregkh@suse.de>
Cc: ext Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101031142539.GA25480@suse.de>
References: <1288177143.12206.22.camel@4fid08082>
	 <20101027124816.7087436a@linux.intel.com>
	 <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
	 <20101027152809.39701917@lxorguk.ukuu.org.uk>
	 <20101029195039.GA26401@suse.de>
	 <20101030140047.GA24464@khazad-dum.debian.net>
	 <1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
	 <20101031142539.GA25480@suse.de>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Mon, 01 Nov 2010 12:41:27 +0200
Message-Id: <1288608087.26073.6.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 15:25 +0100, ext Greg KH wrote:

> > 
> > What I would like to do is:
> > 
> > Control sensors operating mode and regulators based on the userspace
> > activity. If no-one is interested about the sensor, it can be turned
> > totally off including its operating power via regulator framework.
> > 
> > So far the only accepted interface for the small sensor seems to be
> > sysfs. I tried use misc device but it was not accepted.
> 
> Look at the drivers/staging/iio/ subsystem.  It is working on a
> framework that you can use through a character device (I think) to
> properly manage your drivers in this manner.
> 
> Try working with those developers as I think it is what you are looking
> for here.
> 

I took a look to that. It seems that iio is more or less sysfs based.
There are ring buffers and event device which are chardev based
but still the data outside ring buffer and the control is sysfs based.

By getting open and close from sysfs would be nice from the driver
point of view. However, I understand that this is just overhead for
majority of the cases.

Regards,
Samu


