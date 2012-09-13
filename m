Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2IMNze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:55:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60676 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2IMNzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:55:31 -0400
Date: Thu, 13 Sep 2012 15:55:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: Leonard Tse <xiehao5@gmail.com>, ftpadmin@kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, leoli@freescale.com,
        triplex@zh-kernel.org, tshibata@ab.jp.nec.com, k-keiichi@bx.jp.nec.com,
        minchan.kim@gmail.com
Subject: Re: [PATCH]URL is unavailable
Message-ID: <20120913135529.GA23485@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Leonard Tse <xiehao5@gmail.com>, ftpadmin@kernel.org,
	linux-kernel@vger.kernel.org, greg@kroah.com, leoli@freescale.com,
	triplex@zh-kernel.org, tshibata@ab.jp.nec.com,
	k-keiichi@bx.jp.nec.com, minchan.kim@gmail.com
References: <CAHVxiJCv+tzx4rtL2Mu0zAYEurrSwHANwvL_bpDUR7ZMXJdAyg@mail.gmail.com>
 <20120912160306.GA16482@x1.osrc.amd.com>
 <5051334E.4010802@kernel.org>
 <20120913093241.GA15810@liondog.tnic>
 <5051E12F.80001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5051E12F.80001@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:35:43AM -0400, Konstantin Ryabitsev wrote:
> On 13/09/12 05:32 AM, Borislav Petkov wrote:
> > My memory is hazy on this, but after the move, what's the policy on
> > enabling users.kernel.org or userweb.kernel org or some other user web
> > serving thing? I vaguely remember that we don't want to do this anymore
> > but I'm not sure.
> 
> Well, as such system would be the largest security risk, it's
> understandable that we're, err... reticent to have it up anywhere near
> the rest of the infrastructure. :) We do have ssh enabled on two systems
> that require git and release management, but anyone ssh'ing in never
> gets a real shell and is severely locked down with SELinux.
> 
> > In any case, if we do, it would probably be better to have a whole
> > different machine for such stuff and let users upload their stuff again
> > without touching the old backups at all...
> 
> A better question is -- what is the problem we are trying to solve? We
> are not in the business of providing free web hosting -- our aim is to
> facilitate kernel development. We already provide a mechanism for git
> trees and release tarballs. What is lacking is a simple way to publish
> documentation -- it can be currently done with kup, but it's poorly
> suited for uploading and managing many small files.
> 
> We already have a skeleton implementation of pulling such docs from git
> trees (e.g. git docs are published that way). It's on my list of things
> to extend this to a more universal and versatile system that would make
> it easy for anyone to publish arbitrary documentation via their git
> access -- perhaps on a subdomain like docs.kernel.org/treename/[etc]. We
> can even require the use of "git tag -s" -- this will give us both
> adequate security and history of changes.
> 
> I think this would be a better approach than allowing unfettered ssh
> access and upload of arbitrary files.

You're right, I agree with all that but what happens if someone wants
to really upload an arbitrary file - say a tarball of stuff he's been
working on but it is not ready for a repo yet. Or a microcode blob or
whatever. Or even a doctored picture of Alan Cox celebrating the queen
:-)

I think this was the main reason behind userweb but I guess we're better
off finding different storage for stuff like that now.

Thanks.

-- 
Regards/Gruss,
Boris.
