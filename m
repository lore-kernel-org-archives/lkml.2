Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1JZVHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:07:05 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49575 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab1JZVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:07:02 -0400
X-Sasl-enc: nDz6fOticP4h4JFMKGirycEiNY5fgd8evvqOd23p2rUU 1319663222
Date: Wed, 26 Oct 2011 23:06:41 +0200
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Mark Einon <mark.einon@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [GIT PATCH] big staging merge for 3.2
Message-ID: <20111026210641.GA28437@kroah.com>
References: <20111026120725.GA23142@kroah.com>
 <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 03:59:40PM +0200, Linus Torvalds wrote:
> On Wed, Oct 26, 2011 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
> >
> > Here is the big staging merge for 3.2
> >
> > Note, I ended up merging this with your 3.1 release to resolve a merge
> > issue with one of the comedi drivers to fix a build issue.  If you want
> > me to redo the tree without this merge, I'll be glad to do so and let
> > you do it :)
> 
> I don't hate merges that make sense, and that one looks fine. You
> picked a logical merge point, and you wrote a merge message that
> explains it. No problem.
> 
> > There's a lot of patches in here, and the overall diff is quite
> > impressive:
> >  834 files changed, 103718 insertions(+), 230262 deletions(-)
> 
> Hmm... I only get
> 
>  725 files changed, 103936 insertions(+), 180480 deletions(-)
> 
> Which is still good, but nothing like your numbers. Where did you find
> the extra 50k lines?

I don't know, I took it straight from git.

I did a:
	git diff -M --stat --summary master..HEAD

And in that tree master was v3.1 and HEAD was 43a3beb6da994549ec28a9f31727b997a025f958
so if you do:
	git diff -M --stat --summary v3.1..43a3beb6da994549ec28a9f31727b997a025f958

in your tree, I also get the above diffstat:

$ git diff -M --stat --summary v3.1..43a3beb6da994549ec28a9f31727b997a025f958 | grep insert
 834 files changed, 103718 insertions(+), 230262 deletions(-)

Did I do that wrong?  There are a lot of renames, is my default value
for git different than what you might have on your box?  Or am I diffing
the wrong thing here?

thanks,

greg k-h
