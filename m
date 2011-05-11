Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1EKXle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:41:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63441 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab1EKXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:41:31 -0400
Date: Wed, 11 May 2011 16:40:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>
Subject: Re: linux-next: Tree for May 11 (staging/iio/adc + gpio)
Message-Id: <20110511164058.5b562771.randy.dunlap@oracle.com>
In-Reply-To: <20110511152508.0d5d5aa6.sfr@canb.auug.org.au>
References: <20110511152508.0d5d5aa6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DCB1E99.0068:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 15:25:08 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110510:


When GPIOLIB is not enabled and GENERIC_GPIO is not enabled: (not a new problem)

drivers/staging/iio/adc/ad7780.c:247: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)

Its Kconfig entry says:

config AD7780
	tristate "Analog Devices AD7780 AD7781 ADC driver"
	depends on SPI

but surely it should depend on (or select) some GPIO kconfig symbol.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
