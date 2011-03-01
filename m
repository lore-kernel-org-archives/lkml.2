Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1CAVXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:23:25 -0500
Received: from kroah.org ([198.145.64.141]:39347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab1CAVXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:23:24 -0500
Date: Tue, 1 Mar 2011 16:23:50 -0500
From: Greg KH <greg@kroah.com>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Cc: "Mangalampalli, Jayant" <jayant.mangalampalli@intel.com>,
        "Gokulrangan, Venkat R" <venkat.r.gokulrangan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: RFC: [PATCH 0/5] staging: sep: Enable kernel crypto
Message-ID: <20110301212350.GA22953@kroah.com>
References: <1298869824-4246-1-git-send-email-mark.a.allyn@intel.com>
 <20110228212018.GE8851@kroah.com>
 <8A0E4C92AE2D6D40AF99653191DA3231614A0A654E@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA3231614A0A654E@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 02:10:09PM -0700, Allyn, Mark A wrote:
> Greg writes:
> 
> Why?  What does this mean to me?  To users?  You need to sell this new
> feature to me a LOT before I will take it as I really want and need to
> see this driver fixed up first before you can add new features to it.
> 
> thanks,
> 
> greg k-h
> 
> 
> =================
> 
> Greg:
> 
> I agree; I will work on getting the current core driver out of staging prior to making the kernel crypto changes.

First off, please fix your email client to do proper quoting and wrap
lines at 72 columns.  Even Outlook can do this so there really is no
excuse anymore...

> 
> What are the major issues with the core driver? I know about the current items in the TODO list having to do with the unused ioctl calls and structures.
> 
> What other issues are there?

That's a good place to start, fix those up and when you feel you have
addressed everything, ask for a review of the code and we can go from
there.

thanks,

greg k-h
