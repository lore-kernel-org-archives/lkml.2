Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2EBRvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab2EBRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:51:07 -0400
Date: Wed, 2 May 2012 13:50:44 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>, linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Message-ID: <20120502135044.6d815e62@tlielax.poochiereds.net>
In-Reply-To: <4FA11E59.9050004@suse.com>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
	<CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com>
	<CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
	<4FA11E59.9050004@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 17:15:29 +0530
Suresh Jayaraman <sjayaraman@suse.com> wrote:

> On 04/28/2012 09:03 AM, Steve French wrote:
> > The fix makes sense, but it is fairly recent and I haven't had a
> > chance to try it,
> > so unless a new release is imminent, I would prefer to put in the next merge
> > request (I have at least one more fix likely as well) next week.
> 
> We need this fix for -stable as well, right? Please include
> 
>    Cc: stable@vger.kernel.org
> 
> 
> Suresh
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The stable-kernel-rules.txt file says this:

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

...and...

 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.

...and this seems to clearly violate both of those rules. I'd say we
just go with putting it in 3.4 for now, and keep it in mind if someone
comes back later and says that it's needed.

-- 
Jeff Layton <jlayton@redhat.com>
