Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1KYNCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:02:18 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39493 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1KYNCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:02:17 -0500
Date: Fri, 25 Nov 2011 14:02:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 04/11] hwmon: Remove redundant spi driver bus 
 initialization
Message-ID: <20111125140202.37cd4564@endymion.delvare>
In-Reply-To: <20111125095823.GB8908@ericsson.com>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
	<1322148561-25138-4-git-send-email-lars@metafoo.de>
	<20111125095823.GB8908@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Nov 2011 01:58:23 -0800, Guenter Roeck wrote:
> On Thu, Nov 24, 2011 at 10:29:14AM -0500, Lars-Peter Clausen wrote:
> > In ancient times it was necessary to manually initialize the bus field of an
> > spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> 
> s/spi_driver_register/spi_register_driver/
> 
> Otherwise
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Jean, ok if I take this and the others, or do you want to handle it ?

Please take them.

Thanks,
-- 
Jean Delvare
