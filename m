Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2ENUA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:00:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36583 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2ENUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:00:54 -0400
Date: Mon, 14 May 2012 13:00:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net
Subject: Re: [PATCH] staging: comedi: register sysfs device attributes with
 driver core
Message-ID: <20120514200049.GA24362@kroah.com>
References: <201205101805.28589.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205101805.28589.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 06:05:28PM -0700, H Hartley Sweeten wrote:
> Currently the sysfs device attributes are created by the comedi
> core after each comedi device is created. This can lead to a race
> condition where userspace gets an add event before the files are
> created.
> 
> Register the device attributes with the comedi class so that the
> driver core handles creating them and we avoid the race.

Nice job, thanks for making this change.

greg k-h
