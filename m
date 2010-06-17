Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0FQLax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:30:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39627 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143Ab0FQLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:30:52 -0400
Date: Thu, 17 Jun 2010 12:34:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100617123406.17714d00@lxorguk.ukuu.org.uk>
In-Reply-To: <4C18E3B8.7020308@cam.ac.uk>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
	<4C18E3B8.7020308@cam.ac.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So here we would have heading0_input.

Makes complete sense

> 
> As this only applies to the one attribute anyway and maintaining that if we
> ever sweep all these drivers up into a common system would be trivial, this doesn't
> really matter that much.  Still if it doesn't cost anything....
> (though obviously it does if you have userspace code in place!) 

Alan
