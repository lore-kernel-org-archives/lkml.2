Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2DZP1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:27:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:47971 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2DZP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:27:46 -0400
Date: Thu, 26 Apr 2012 08:27:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: George Nychis <gnychis@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware
 details)
Message-ID: <20120426152742.GB15674@kroah.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
 <20120423212144.GA3378@kroah.com>
 <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
 <20120423225603.GA23276@kroah.com>
 <20120426152310.GB26692@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426152310.GB26692@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:23:10PM +0100, Mark Brown wrote:
> On Mon, Apr 23, 2012 at 03:56:03PM -0700, Greg KH wrote:
> 
> > You do realize just how old and obsolete your 3.0.8 kernel is, right?  I
> > suggest you update to the latest version, or, if you are stuck with this
> > kernel, go ask the vendor who provided it to you for support, as they
> > are the best ones to help you out.
> 
> Unfortunately 3.0 is what ICS is based off so the overwhelming majority
> of vendor code is going to be based on it until the next Android
> release.  With my vendor hat on I have to say that we find our upstream
> first policy extremely effective so we shouldn't be part of the issue.

That's great, and understandable, but the original poster said they were
using an old Ubuntu release, and the ability for the community to
support bugs in older kernel releases like this is very difficult as you
well know.

The next Android release should be "any day now" so hopefully we move on
from 3.0 soon...

thanks,

greg k-h
