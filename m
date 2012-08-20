Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2HTVta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:49:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18205 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab2HTVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:49:28 -0400
Date: Mon, 20 Aug 2012 14:49:17 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, abbotti@mev.co.uk
Subject: Re: [PATCH 09/20] staging: comedi: adv_pci1723: fix initial dio
 subdevice state and io_bits
Message-ID: <20120820214916.GA11795@mwanda>
References: <201208171817.38918.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208171817.38918.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 06:17:38PM -0700, H Hartley Sweeten wrote:
> +	if (this_board->n_diochan) {
> +		s = dev->subdevices + subdev;

This pointer math sucks still...  I feel like the unreadable code is
part of what caused this bug.

We don't have to change these all at once.  If we fix only one line,
then at least one line will be readable and that is one more than
before so *improvement*.

regards,
dan carpenter

