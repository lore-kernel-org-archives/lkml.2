Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2DZTsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:48:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55202 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2DZTst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:48:49 -0400
Date: Thu, 26 Apr 2012 12:48:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix bug where kfree is called twice.
Message-ID: <20120426194845.GA10724@kroah.com>
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com>
 <20120426063858.GC6447@mwanda>
 <4F990AE0.8040400@ozmodevices.com>
 <20120426115459.GE6447@mwanda>
 <4F99813B.1010806@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F99813B.1010806@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 06:09:15PM +0100, Rupesh Gujare wrote:
> Hi Greg,
> 
> >Everything goes into linux-next first. That should have been put
> >in the changelog. "We are seeing occasional crashes under load" or
> >whatever... It's Greg's call and all, but generally it can't hurt
> >to ask nicely if you want stuff merged it into 3.4 as well. ;)
> 
> Is it possible to queue it up for 3.4 as well ?

Yes, now done so.

