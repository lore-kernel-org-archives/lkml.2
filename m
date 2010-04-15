Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0DOP5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:57:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1490 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab0DOP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:57:18 -0400
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100415131153.0e383ef3@lxorguk.ukuu.org.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	 <20100414125136.23181.16788.stgit@localhost.localdomain>
	 <4BC5C7A8.1040807@cam.ac.uk> <20100414153234.22765666@lxorguk.ukuu.org.uk>
	 <4BC5D681.20707@jic23.retrosnub.co.uk>
	 <20100414161904.713eef78@lxorguk.ukuu.org.uk>
	 <1271280993.1833.36.camel@Joe-Laptop.home>
	 <20100415131153.0e383ef3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 08:57:16 -0700
Message-ID: <1271347036.1726.57.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 13:11 +0100, Alan Cox wrote:
> > Argument alignment
> Makes it take more space

Makes it look more like most kernel code.

> > Make chars static
> Not sure I see the point (compiler generates good code anyway)

Internal consistency.  2 use areas had it, 1 didn't.



