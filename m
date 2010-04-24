Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0DXQod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 12:44:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0DXQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 12:44:31 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: xfs@oss.sgi.com
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Sat, 24 Apr 2010 18:44:22 +0200
User-Agent: KMail/1.9.10
Cc: Dave Chinner <david@fromorbit.com>, opensuse-kernel@opensuse.org,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard> <201004131142.33518.hpj@urpla.net>
In-Reply-To: <201004131142.33518.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004241844.23482.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/q8liCSqC/EfiQ0rRd6mBVzoJ4OQJX5VYHtOE
 vRPHsbweu3GGetSJGxh63yiqXnlZy30R0AO+FDLlDgJ7ZrcuC8
 IYxik8Mt2QDlYLK7evtyCWPMCPJ2mn/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010, 11:42:33 Hans-Peter Jansen wrote:
> On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> > On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> > > Dave, may I ask you kindly for briefly elaborating on the worst
> > > consequences of just reverting this hunk, as I've done before?
> >
> > Well, given that is the new shrinker code generating the warnings,
> > reverting/removing that hunk will render the patch useless :0
>
> Excuse me, I didn't express myself well. I'm after the consequences of
> applying the revert, that I posted a few messages above.
>
> > I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> > now....
>
> Cool, thanks.

Obviously and not totally unexpected, really fixing this is going to take 
more time.

FYI, 2.6.33.2 is still affected from this issue. 

Greg, you might search for a server using xfs filesystems and and a i586 
kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well), log in as an 
ordinary user, do a "du" on /usr, and wait for the other users screaming...

BTW, all affected kernels, available from 
http://download.opensuse.org/repositories/home:/frispete: have the 
offending patch reverted (see subject), do run fine for me (on this 
aspect).

Will you guys pass by another round of stable fixes without doing anything 
on this issue?

Dave, this is why I'm kindly asking you: what might be the worst 
consequences, if we just do the revert for now (at least for 2.6.33), until 
you and Nick came to a final decision on how to solve this issue in the 
future.

Just a brief note would be fine.

Cheers,
Pete
