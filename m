Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0GVSAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:00:49 -0400
Received: from kroah.org ([198.145.64.141]:60307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab0GVSAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:00:48 -0400
Date: Thu, 22 Jul 2010 10:55:35 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, ss@aao.gov.au, gregkh@suse.de
Subject: Re: [PATCH] Staging: dt3155: Remove copy_to_user for ioctl's
 DT3155_{STOP|START}
Message-ID: <20100722175535.GA28673@kroah.com>
References: <201007201757.52928.hartleys@visionengravers.com>
 <4C46A85C.2090608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C46A85C.2090608@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 09:57:16AM +0200, Jiri Slaby wrote:
> On 07/21/2010 02:57 AM, H Hartley Sweeten wrote:
> > The ioctl's DT3155_STOP and DT3155_START are defined with the macro
> > _IO indicating that they have no parameters. They should not be using
> > copy_to_user to return data to user space.
> 
> This is not a reason for removing them. You should check what real users
> do/expect and base your reasoning on the top of that.
> 
> So could you investigate that?

I agree, we can't remove this, it changes the functionality of the
kernel in a way that userspace might not be expecting.

thanks,

greg k-h
