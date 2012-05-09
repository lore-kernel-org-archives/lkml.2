Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab2EIX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:57:30 -0400
Received: from kandzendo.ru ([195.178.208.66]:45771 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969Ab2EIX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:57:29 -0400
Date: Thu, 10 May 2012 03:57:23 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120509235723.GA7404@ioremap.net>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:37:56AM +0200, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
> Well, the data read/written through this file is actually directly
> "passed" on to the device. There are two bits which reflect the current
> state of the PIO pins of the DS28E04. However, I must admit that this
> could also be implemented as regular sysfs attributes.

Greg, could you please describe what is exactly wrong with binary sysfs
file? Or am I missing that it is not usual sysfs file but some special
stuff?

-- 
	Evgeniy Polyakov
