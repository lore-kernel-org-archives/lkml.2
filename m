Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab0FQNKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:10:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:7729 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab0FQNKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,431,1272870000"; 
   d="scan'208";a="808913379"
Date: Thu, 17 Jun 2010 13:46:50 +0100
From: Alan Cox <alan@linux.intel.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100617134650.501b14bb@linux.intel.com>
In-Reply-To: <201006171426.08442.oneukum@suse.de>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
	<201006161443.45375.oneukum@suse.de>
	<20100617122048.142def43@lxorguk.ukuu.org.uk>
	<201006171426.08442.oneukum@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Its an array anyway - there isn't as such a 'correct macro' nor
> > does it need to be using one.
> 
> So why does he use this unstructured data? Do we just hope the
> compiler is good enough on big endian architectures?

Its an array because it comes from an i2c bus which is a bytestream.
There is no structure on the i2c bus and the device is defined to
return a pair of bytes in this manner.

Alan
