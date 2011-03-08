Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1CHFJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:09:41 -0500
Received: from kroah.org ([198.145.64.141]:59444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1CHFJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:09:39 -0500
Date: Mon, 7 Mar 2011 21:07:59 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        stable@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [stable] [PATCH] [stable-37] ideapad: read brightness setting
 when have brightness key notify
Message-ID: <20110308050759.GA12184@kroah.com>
References: <1299494125-9655-1-git-send-email-ike.pan@canonical.com>
 <20110307161805.GB9088@kroah.com>
 <4D759675.8020600@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D759675.8020600@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:37:41AM +0800, Ike Panhc wrote:
> On 03/08/2011 12:18 AM, Greg KH wrote:
> > On Mon, Mar 07, 2011 at 06:35:25PM +0800, Ike Panhc wrote:
> >> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922
> >>
> >> On ideapad Y530, the brightness key notify will be blocked if the last notify
> >> is not responsed by getting the brightness value. Read value when we get the
> >> notify shall fix the problem and will not have any difference on other ideapads.
> >>
> >> This patch is made against 2.6.37.y and this bug impacts kernel after 2.6.37.
> >>
> >> The equivalent-fix patch is not in upstream yet. Since the policy of stable tree
> >> is changed and .38 kernel is going to finalize.
> > 
> > What "policy of the stable tree is changed"?  Huh?
> 
> I thought we will have stable release on lastest kernel only[1]. Since the .38 is
> going to release soon. It seems I do not have much time for .37 stable release.
> 
> I hope I do not miss something.
> 
> [1] https://lkml.org/lkml/2010/12/2/388

I think you miss the fact that if by the time your patch makes it into
Linus's tree, and we have moved on to not supporting .37 anymore, then
no one will care about .37 so it doesn't matter at all.

> >> I think to post this patch for stable kernel now should be a good
> >> idea.
> > 
> > Have you not read the Documentation/stable_kernel_rules.txt and seen
> > that this is totally and completly not allowed?  Why is it suddenly not
> > true?
> > 
> > confused,
> 
> Sorry about the confusing. The same patch for upstream is posted[2] but not merged
> yet. It looks like a now-or-never situation to me. That's why I post and write the
> concerns in comment.

You need to follow the documented and well explained rules, they are
there for a very good reason, please don't try to subvert them,
otherwise you will just end up in my kill file.

thanks,

greg k-h
