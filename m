Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0LXKqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 05:46:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:39386 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab0LXKqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 05:46:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,223,1291622400"; 
   d="scan'208";a="366161049"
Date: Fri, 24 Dec 2010 11:45:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Paul Fox <pgf@laptop.org>, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Subject: Re: MFD cell structure and sharing of resources
Message-ID: <20101224104518.GB27832@sortiz-mobl>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
 <20101216103550.GA5946@sortiz-mobl>
 <AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Dec 16, 2010 at 03:38:52PM +0000, Daniel Drake wrote:
> Hi Samuel,
> 
> Thanks for your valuable input here!
Thanks for your patience. I've been swamped at work with other projects, sorry
for the delay.

> I have one solution in mind but I'm not sure if it goes beyond your
> definition of what a mfd cell should be:
> 
> cs5535-mfd creates and registers a MFD cell specifically for
> olpc-xo1-pm if it finds itself running on an XO laptop. The cell has
> the 2 resources that are needed by that driver, and has name
> "olpc-xo1-pm". Therefore our sysfs paths start with:
> /sys/devices/pci0000:00/0000:00:0f.0/olpc-xo1-pm/
That is stretching things a bit, but I'd be ok with that solution.
In theory, you wouldn't even need to check if you're on an XO laptop, except
for saving a few bytes at runtime.

One more thing: What about my proposal of defining IO routines from the MFD
driver, and using those from your subdevices driver ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
