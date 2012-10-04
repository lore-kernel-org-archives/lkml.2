Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2JDNfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:35:14 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:54483 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2JDNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:35:11 -0400
Date: Thu, 4 Oct 2012 09:35:04 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121004133504.GA5599@elliptictech.com>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org>
 <20121003204919.GA9092@outflux.net>
 <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-03 13:54 -0700, Linus Torvalds wrote:
> On Wed, Oct 3, 2012 at 1:49 PM, Kees Cook <kees@outflux.net> wrote:
> > I think the benefits of this being on by default outweigh glitches
> > like this. Based on Nick's email, it looks like a directory tree of his
> > own creation.
> 
> I agree that *one* report like this doesn't necessarily mean that we
> need to turn it off, if Nick is happy to just fix up his script and
> it's all local.
> 
> However, I suspect we'll see more. And once that happens, we're not
> going to keep a default that breaks peoples old scripts, and we're
> going to have to rely on distributions (or users) explicitly setting
> it.

Yes, it is a directory of my own creation, intended as a place for users
(read: me) to stick stuff on the local disk as opposed to on NFS.  It's
pretty trivial for me to fixup everything to not need this symlink
anymore (and I suspect it is the only offender); I just created the
symlink in the first place so that I wouldn't have to change anything
else.

(While on /this/ machine I created the directory, I have used shared lab
machines with a similar setup).

The thing that bothers me most about all this is that it's basically
impossible to see why things are failing without digging through the git
tree or posting to the mailing list (or recalling earlier mailing list
discussions about the restriction, as I vaguely do now).  You just
suddenly get "permission denied" errors when all the permissions
involved look fine.  As far as I know, the owner, group and mode of
symlinks have always been completely meaningless.  Upgrade to 3.6, and
they're suddenly meaningful in extremely non-obvious ways.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

