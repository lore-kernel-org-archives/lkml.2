Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2HPXIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 19:08:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2HPXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 19:08:21 -0400
Date: Thu, 16 Aug 2012 16:08:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: Re: [PATCH 0/3] staging: zcache+ramster: move to new code base and
 re-merge
Message-ID: <20120816230817.GA14757@kroah.com>
References: <1345156293-18852-1-git-send-email-dan.magenheimer@oracle.com>
 <20120816224814.GA18737@kroah.com>
 <9f2da295-4164-4e95-bbe8-bd234307b83c@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f2da295-4164-4e95-bbe8-bd234307b83c@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 03:53:11PM -0700, Dan Magenheimer wrote:
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Subject: Re: [PATCH 0/3] staging: zcache+ramster: move to new code base and re-merge
> > 
> > On Thu, Aug 16, 2012 at 03:31:30PM -0700, Dan Magenheimer wrote:
> > > Greg, please pull for staging-next.
> > 
> > Pull what?
> 
> Doh!  Sorry, I did that once before and used the same template for the
> message.  Silly me, I meant please apply.  Will try again when my
> head isn't fried. :-(
> 
> > You sent patches, in a format that I can't even apply.
> > Consider this email thread deleted :(
> 
> Huh?  Can you explain more?  I used git format-patch and git-email
> just as for previous patches and even checked the emails with
> a trial send to myself.  What is un-apply-able?

Your first patch, with no patch description, and no signed-off-by line.

Come on, you know better...

On a larger note, I _really_ don't want a set of 'delete and then add it
back' set of patches.  That destroys all of the work that people had
done up until now on the code base.

I understand your need, and want, to start fresh, but you still need to
abide with the "evolve over time" model here.  Surely there is some path
from the old to the new codebase that you can find?

Also, I'd like to get some agreement from everyone else involved here,
that this is what they all agree is the correct way forward.  I don't
think we have that agreement yet, right?

greg k-h
