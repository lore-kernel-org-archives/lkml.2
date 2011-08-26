Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1HZSrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1HZSrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:47:51 -0400
Date: Fri, 26 Aug 2011 14:47:42 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dynamic debug: cleanups + compile fix
Message-ID: <20110826184742.GA2469@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com>
 <20110826182900.GA30226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826182900.GA30226@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:29:00AM -0700, Greg KH wrote:
> On Thu, Aug 25, 2011 at 01:34:06PM -0400, Jason Baron wrote:
> > Hi,
> > 
> > This is a re-post of the last 3 patches, as requested by Greg:
> > https://lkml.org/lkml/2011/8/11/378
> > 
> > I've also added a compile fix that Randy Dunlap found in the -next tree.
> 
> Care to redo this based on the comments received so far?
> 

Hi,

I re-posted 3/4 based on the comments already. The comment on patch #1
regarding adding macro parenthesis, I don't believe makes any functional
change...do you still need a re-post the series?

Thanks,

-Jason
