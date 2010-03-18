Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0CRWzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:55:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:35330 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528Ab0CRWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:54:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,270,1267430400"; 
   d="scan'208";a="256342665"
Date: Thu, 18 Mar 2010 15:54:32 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Alex Chiang <achiang@hp.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100318225432.GA6166@xanatos>
References: <20100316204845.GJ8278@ldl.fc.hp.com>
 <20100309184723.GA31374@kroah.com>
 <20100316212445.GA15729@xanatos>
 <20100316214014.GA8839@kroah.com>
 <20100318213308.GA5461@xanatos>
 <20100318221958.GB3299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318221958.GB3299@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 03:19:58PM -0700, Greg KH wrote:
> On Thu, Mar 18, 2010 at 02:33:08PM -0700, Sarah Sharp wrote:
> > Yes, I did par down the duplicate/redundant messages, but I still want
> > to see very detailed messages when I think there's a hardware problem.
> > 
> > What if I removed the debug config option for xHCI, allowed people to
> > use dynamic debugging to enable debugging for specific xHCI files, but
> > also allowed them to set the log level through a debugfs file?  That way
> > people could still control the variety of messages that they see, but
> > they can also change the level of debugging dynamically.
> 
> Sure, that might work, but I'd recommend tracing for the most part,
> that's what it is there for :)

Ok, I'll look into adding trace events.

Sarah Sharp
