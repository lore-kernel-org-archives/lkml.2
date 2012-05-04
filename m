Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab2EDSuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:50:18 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:57621 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2EDSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:50:17 -0400
Date: Fri, 4 May 2012 11:50:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net
Subject: Re: [PATCH] staging: comedi: remove debug tracing in vmk80xx driver
Message-ID: <20120504185012.GA11426@kroah.com>
References: <201205041123.55261.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205041123.55261.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:23:54AM -0700, H Hartley Sweeten wrote:
> The vmk80xx driver uses a non-existant Kconfig symbol to enable
> function call debug tracing. This output is really just noise
> and doesn't serve any useful purpose. Remove all it's uses in
> the driver.

Nice.

Really, all tracing should be removed from pretty much all drivers, as
we have good built-in tracing tools in the kernel now, so rolling your
own is not needed.

thanks,

greg k-h
