Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0D3ROt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:14:49 -0400
Received: from kroah.org ([198.145.64.141]:58417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807Ab0D3RNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:32 -0400
Date: Thu, 29 Apr 2010 14:17:25 -0700
From: Greg KH <greg@kroah.com>
To: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] Mobile security processor driver
Message-ID: <20100429211725.GA14909@kroah.com>
References: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
 <20100429033625.GA27503@kroah.com>
 <753F67ADE6F5094C9F1DBA00D1BAA8D32551825DAC@orsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <753F67ADE6F5094C9F1DBA00D1BAA8D32551825DAC@orsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Apr 29, 2010 at 01:48:25PM -0700, Epshteyn, Eugene wrote:
> Hi Greg,
> 
> Mark asked me to post the patches for him.

Then say that :)

And why would Mark need someone else to do that?

> These patches are on 2.6.34 with the 0415 next patch.

Then say that :)

> We were hoping to get more comments from people to add to TODO list,
> so that the vendor can plan their work to fix the issues and make the
> driver more acceptable to the community.

Isn't Intel the "vendor" here?  If not, why not have them directly
interact with us, you do not want to be put into the middle, it only
slows things down for everyone and is not how Linux kernel development
works.

> The driver already went through some clean-up, but much more work is
> still needed.

Yes, that TODO list is quite large already, fix up all of those and then
ask for more review please.  Reviewing code you know needs lots of work
isn't all that nice to do.

So again, please fix all of that first, get those changes accepted, and
then we can talk :)

thanks,

greg k-h
