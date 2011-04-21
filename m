Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1DUUIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:08:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54917 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1DUUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:08:38 -0400
Date: Thu, 21 Apr 2011 22:08:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Joe Perches <joe@perches.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421200836.GA31709@merkur.ravnborg.org>
References: <20110421192117.GA14249@redhat.com> <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com> <4DB087EC.1010205@caviumnetworks.com> <1303415086.24766.84.camel@Joe-Laptop> <20110421195801.GA15126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421195801.GA15126@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 03:58:02PM -0400, Dave Jones wrote:
> On Thu, Apr 21, 2011 at 12:44:46PM -0700, Joe Perches wrote:
>  > On Thu, 2011-04-21 at 12:39 -0700, David Daney wrote:
>  > > Would it make any sense to add a config option to enable the spew for 
>  > > those that wanted to see it?
>  > 
>  > Add it to make W=1 instead?
>  > See commit 4a5838ad9d2d
> 
> This patch does that. Though I question the usefulness of W=1.
> I just built powernow-k8.o with W=1, and got 4030 lines of output.
> That's just insane.

It was discussed to do:
W=1 - the most usefull warnings
W=2 - the less usefull warnings
W=3 - the noise

Or somthing like that.
But no-one stepped up doing the classification then.
Should be simple to do.

My gcc (4.3.2) barfed over -Wno-unused-but-set-variable.
So your patch needs to check if the option is supported.

	Sam
