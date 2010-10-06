Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab0JFVWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:22:13 -0400
Received: from kroah.org ([198.145.64.141]:59466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab0JFVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:22:11 -0400
Date: Wed, 6 Oct 2010 14:21:20 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32.y] ipmi: Fix hard-code path ipmi exit path panic
Message-ID: <20101006212120.GB16320@kroah.com>
References: <4C9CDEEF.4030304@kernel.org>
 <20101006210120.GB6184@kroah.com>
 <4CACE41F.1020905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CACE41F.1020905@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:03:27PM -0700, Yinghai Lu wrote:
> On 10/06/2010 02:01 PM, Greg KH wrote:
> > On Fri, Sep 24, 2010 at 10:25:03AM -0700, Yinghai Lu wrote:
> >>
> >> Wing found panic on X4800, after he installed Sun own special version of ipmitool.
> > 
> > Is this an issue on 2.6.35?  If so, please lt the ipmi maintainer know
> > about it so this patch can get into Linus's tree and then backported to
> > the stable releases.
> 
> only for 2.6.32.y

Why?  What happened between then to keep this from happening in .35?
If you find the patch that fixes it, that is what we need to apply to
the .32-stable tree.

thanks,

greg k-h
