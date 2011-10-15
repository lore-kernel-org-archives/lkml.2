Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1JOQdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 12:33:39 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47468 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab1JOQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 12:33:38 -0400
X-Sasl-enc: bA3FuJkkrHLb6Jtsz3DCAsjDdSfSxyYfMZE6O91TCTms 1318696417
Date: Sat, 15 Oct 2011 09:18:29 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Answers to some common kernel.org account questions
Message-ID: <20111015161829.GA19317@kroah.com>
References: <20111014152100.GA11717@kroah.com>
 <20111015064242.GA23349@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015064242.GA23349@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 08:42:42AM +0200, Willy Tarreau wrote:
> Hi Greg,
> 
> On Fri, Oct 14, 2011 at 09:21:00AM -0600, Greg KH wrote:
> > WHAT ABOUT FILE UPLOADS?
> > 
> > The "robot signing" of uploaded files that was used in the past is no
> > longer considered to be sufficiently secure, so a new policy has been
> > instituted.  A new tool ("kup") has been developed to help with the
> > implementation of that policy; it works in a manner similar to the
> > upload system used by the Debian project.
> > 
> > The kup tool will require developers to sign files with their PGP key
> > prior to uploading to kernel.org.  This mechanism will keep the private
> > signing keys from ever being stored on kernel.org (or any other server).
> > More information will be made available once the file upload capability
> > is restored.
> 
> Please reassure me, we will only have to upload the sig, not the whole
> file ?

That is what we are working on doing, there are still a few things left
to resolve to enable this to work properly, which is why it hasn't been
implemented yet.

thanks,

greg k-h
