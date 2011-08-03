Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1HCXex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:34:53 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58912 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215Ab1HCXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:34:32 -0400
X-Sasl-enc: Bx0gGA5y6df9ZfM+GCaljFR+qwawxd4cir/qLFQvCF5x 1312414471
Date: Wed, 3 Aug 2011 16:34:26 -0700
From: Greg KH <greg@kroah.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: andrew morton <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        nbd-general@lists.sourceforge.net
Subject: Re: [PATCH] nbd: nbd sysfs framework
Message-ID: <20110803233426.GA18216@kroah.com>
References: <CAECXXi5kZJk+86-2SJRWqMUCj31cL4tb1qTbaueMxeEg2VFcDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAECXXi5kZJk+86-2SJRWqMUCj31cL4tb1qTbaueMxeEg2VFcDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 07:15:51PM -0400, Paul Clements wrote:
> Description: The patch creates a new sysfs entry framework for nbd.

Why?  What does this buy us except an increase in code size for no added
benifit?  You seem to be stripping out the driver layer here and using
"raw" kobjects, why?  That's generally never a good idea (hint, I think
you just caused a race and userspace bug with your change as well
because of this...)

confused,

greg k-h
