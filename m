Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1ASUwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:52:25 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:57373 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1ASUwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:52:24 -0500
Date: Wed, 19 Jan 2011 21:52:44 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Earl Chew <echew@ixiacom.com>
Cc: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119205243.GC17399@local>
References: <4D366104.1000400@ixiacom.com>
 <20110119145619.GA17399@local>
 <4D370654.7020400@ixiacom.com>
 <20110119163005.GA12979@kroah.com>
 <4D371A35.5000009@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D371A35.5000009@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:07:01AM -0800, Earl Chew wrote:
> 
> >> I've added uio_device_chrdev() alongside uio_device_name() to allow
> >> us to figure out the coordinates of the Linux UIO device.
> > 

There's a small library with helper functions. Among other things, they
allow searching the UIO device node by name (the name you gave your device
in uio_info->name). The library is here:

git://git.linutronix.de/projects/libUIO.git

or with gitweb:

http://git.linutronix.de/gitweb.cgi?p=projects/libUIO.git;a=summary

Thanks,
Hans

