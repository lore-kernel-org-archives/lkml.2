Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1EKVOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:14:52 -0400
Received: from kroah.org ([198.145.64.141]:59135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1EKVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:14:49 -0400
Date: Wed, 11 May 2011 14:14:01 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
Message-ID: <20110511211401.GC4893@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:54:12AM -0700, matt mooney wrote:
> Hi Greg,
> 
> I am interested in hearing your thoughts on the userspace interface?

Which one?  The user/kernel interface?

> Even as is, it definitely needs some work. For one thing I was thinking
> of removing the debug flag from userspace. The userspace utilites are
> not using it anyway, and it is not 100% working yet.

I haven't looked at the interface much yet, what is your issue with the
debug flag?

To make things easier, and allow you to be able to change the userspace
interface, I suggest moving the userspace code into the kernel tree, and
building it here.  That would allow you to move forward with changing
things easier, doing it all in one place allows you to keep stuff in
sync, and provides people an easier way to actually get the needed tools
to drive the code.

What do you think about doing that?

I've applied a number of these patches, care to respin the others and
resend them based on my latest tree?

thanks,

greg k-h
