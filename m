Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1IFXyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:54:41 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59480 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab1IFXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:54:16 -0400
X-Sasl-enc: XHlpBjxTL9Ylpb9Dxsd7UW8EYniXh1Og7Wn0d482seMd 1315353255
Date: Tue, 6 Sep 2011 16:52:53 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        hverkuil@xs4all.nl, gregkh@suse.de, mchehab@redhat.com
Subject: Re: [PATCH] Staging: dt3155v4l: Convert printk's to pr_<level>
Message-ID: <20110906235253.GC26281@kroah.com>
References: <201109011653.56089.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109011653.56089.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 04:53:55PM -0700, H Hartley Sweeten wrote:
> Convert all the printk(KERN_<level>) messages in the driver to pr_<level>()
> and use pr_fmt to provide the module name.

What's wrong with using dev_* instead of pr_*?  Lots of these should be
converted to that format instead, right?

thanks,

greg k-h
