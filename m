Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1BQR1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:27:32 -0500
Received: from imr4.ericy.com ([198.24.6.8]:40057 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1BQR1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:27:30 -0500
Date: Thu, 17 Feb 2011 09:26:39 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (k10temp) add support for AMD Family 12h/14h
 CPUs
Message-ID: <20110217172639.GA19982@ericsson.com>
References: <4D5CDAD0.7030006@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D5CDAD0.7030006@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:22:40AM -0500, Clemens Ladisch wrote:
> Add the PCI ID to support the internal temperature sensor of the
> AMD "Llano" and "Brazos" processor families.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Applied, thanks.

Since it meets the requirements for a stable patch, I applied it to the
patch list for 2.6.38 and added Cc: stable@kernel.org.

Guenter
