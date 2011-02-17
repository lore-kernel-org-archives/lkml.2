Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1BQSIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:08:54 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:18356 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1BQSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:08:52 -0500
Date: Thu, 17 Feb 2011 19:08:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (k10temp) add support for AMD Family 12h/14h 
 CPUs
Message-ID: <20110217190838.381962f6@endymion.delvare>
In-Reply-To: <20110217172639.GA19982@ericsson.com>
References: <4D5CDAD0.7030006@ladisch.de>
	<20110217172639.GA19982@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 09:26:39 -0800, Guenter Roeck wrote:
> On Thu, Feb 17, 2011 at 03:22:40AM -0500, Clemens Ladisch wrote:
> > Add the PCI ID to support the internal temperature sensor of the
> > AMD "Llano" and "Brazos" processor families.
> > 
> > Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> Applied, thanks.
> 
> Since it meets the requirements for a stable patch, I applied it to the
> patch list for 2.6.38 and added Cc: stable@kernel.org.

Can we have a sensors-detect patch too?

Thanks,
-- 
Jean Delvare
