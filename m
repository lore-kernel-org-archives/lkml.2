Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0DNOPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:15:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48974 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134Ab0DNOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:15:17 -0400
Date: Wed, 14 Apr 2010 15:19:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Various intel small device drivers
Message-ID: <20100414151903.0f367563@lxorguk.ukuu.org.uk>
In-Reply-To: <4BC5C96B.7050901@cam.ac.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414153052.4e07f0cc@hyperion.delvare>
	<20100414144912.12c83f51@lxorguk.ukuu.org.uk>
	<4BC5C96B.7050901@cam.ac.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you like, feel free to (re)start an argument with Linus on the ambient light
> sensor front.  Or see that thread for yet another round about discussion of
> where these sensors should be. 
> 
> http://lkml.org/lkml/2010/3/1/367
> 
> Basically if it is primarily an input device for human interaction, see if

Its a sensor on an embedded board, it might be managing the backlight or
measuring the dirt level in a sewage pipe depending upon application.

> Dmitry is willing to take it into input (though note he may quite rightly
> take some convincing!)

Its easy enough to make it an input device but that would then end up
with polled_input_dev which keeps waking up and costs battery. A lot of
the polled input model is somewhat broken in that regard but I can see
Linus point.

> Otherwise, misc with the intent to sweep them all up when an agreed upon
> subsystem is in place.

Looks like goes into misc for the moment with all the other light sensors
and I'll see if I can merge it with the 29007 support while I am at it.

Thanks

Alan
