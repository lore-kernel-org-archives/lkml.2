Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0DNNpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:45:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54861 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755481Ab0DNNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:45:01 -0400
Date: Wed, 14 Apr 2010 14:49:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Various intel small device drivers
Message-ID: <20100414144912.12c83f51@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414153052.4e07f0cc@hyperion.delvare>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414153052.4e07f0cc@hyperion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Kalhan Trisal (4):
> >       emc1403: thermal sensor support
> >       liss331d1: accelerometer driver
> >       isl29020: ambient light sensor
> >       hmc6352: Add driver for the HMC6352 compass
> 
> The liss331d1, isl29020 and hmc6352 are not hardware monitoring drivers

Disagree somewhat. In fact on close grepping I find that there is another
related lis33 implementation in drivers/hwmon already 8)

Given all the accelerometers are in drivers/hwmon where do you think they
should be, and do you have pending patches to move the others ?

I'd also be interested where you think the compass fits if its not hwmon,
ditto the ambient light sensor ?

I'll bounce the emc1403 onto lm-sensors.

Thanks
Alan
