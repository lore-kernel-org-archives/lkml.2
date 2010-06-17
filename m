Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0FQP44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:56:56 -0400
Received: from bamako.nerim.net ([62.4.17.28]:51535 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab0FQP4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:56:54 -0400
Date: Thu, 17 Jun 2010 17:56:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100617175650.482e098f@hyperion.delvare>
In-Reply-To: <20100617161754.39bd116e@lxorguk.ukuu.org.uk>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
	<20100616151056.181234b0@hyperion.delvare>
	<20100617125056.6d648ee7@lxorguk.ukuu.org.uk>
	<4C1A12C6.6070704@cam.ac.uk>
	<20100617141440.030f1de9@lxorguk.ukuu.org.uk>
	<20100617165250.5986fbf7@hyperion.delvare>
	<20100617161754.39bd116e@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 16:17:54 +0100, Alan Cox wrote:
> > These functions are supposed to return count on success. Instead, you
> > are returning 1.
> 
> Ah yes - I only tested with 1 byte sized I/O.

Good.

> Fixed - do you want this to go via the I2C tree ?

No.

-- 
Jean Delvare
