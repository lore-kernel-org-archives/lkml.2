Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0ETSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:00:22 -0400
Received: from kroah.org ([198.145.64.141]:38495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab0ETSAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:00:16 -0400
Date: Thu, 20 May 2010 10:47:43 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] tagged sysfs support
Message-ID: <20100520174743.GA17077@kroah.com>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:30:23AM -0700, Eric W. Biederman wrote:
> 
> The main short coming of using multiple network namespaces today
> is that only network devices for the primary network namespaces
> can be put in the kobject layer and sysfs.
> 
> This is essentially the earlier version of this patchset that was
> reviewed before, just now on top of a version of sysfs that doesn't
> need cleanup patches to support it.
> 
> I have been running these patches in some form for well over a
> year so the basics should at least be solid.  
> 
> This patchset is currently against 2.6.34-rc1.
> 
> This patchset is just the basic infrastructure a couple of more pretty
> trivial patches are needed to actually enable network namespaces to use this.
> My current plan is to send those after these patches have made it through
> review.

All queued up now.

thanks,

greg k-h
