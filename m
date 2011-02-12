Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1BLIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:16:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:38469 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1BLIQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:16:21 -0500
Date: Sat, 12 Feb 2011 00:16:17 -0800
From: Andres Salomon <dilinger@queued.net>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 03/17] jz4740: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110212001617.43b42988@queued.net>
In-Reply-To: <20110212035138.GA6859@ericsson.com>
References: <20110211180250.483936cc@queued.net>
	<20110212035138.GA6859@ericsson.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 19:51:38 -0800
Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> On Fri, Feb 11, 2011 at 09:02:50PM -0500, Andres Salomon wrote:
> > 
> > No need to explicitly set the cell's platform_data/data_size.
> > 
> > Modify clients to use mfd_get_cell helper function instead of
> > accessing platform_data directly.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> I don't see anything different to the previous version of this patch
> (which was Acked by Jean already), and there is no changelog available
> for the complete series either.

It is exactly the same; sorry, I should've added Jean's ACK.

For patches where there was a difference, I tried to have the patch
description be more.. descriptive.
