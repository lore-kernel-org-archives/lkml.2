Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0DOMHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 08:07:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53741 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468Ab0DOMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:07:43 -0400
Date: Thu, 15 Apr 2010 13:11:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100415131153.0e383ef3@lxorguk.ukuu.org.uk>
In-Reply-To: <1271280993.1833.36.camel@Joe-Laptop.home>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125136.23181.16788.stgit@localhost.localdomain>
	<4BC5C7A8.1040807@cam.ac.uk>
	<20100414153234.22765666@lxorguk.ukuu.org.uk>
	<4BC5D681.20707@jic23.retrosnub.co.uk>
	<20100414161904.713eef78@lxorguk.ukuu.org.uk>
	<1271280993.1833.36.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Argument alignment

Makes it take more space

> Spacing

Mostly dropped

> Make chars static

Not sure I see the point (compiler generates good code anyway)

> Remove prefixes from dev_<level> logging

Good point.

