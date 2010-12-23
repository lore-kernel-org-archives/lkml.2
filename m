Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0LWNNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:13:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34522 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0LWNND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=bjDYhdXNRlpnVppYkj1SSkhZ02MaVlr5o6TPZkkyYPG1S0nZ+rEPH2lDO+cv7UnEgl
         LchW7Mu26Z+6tqwf5YQoefn0mfuz9KJYDbDuHStN3+iY3oftmQvTC/KVWpfRxS/jQTQr
         57lIhXjVZZbtVk3+THLAG4lPraj7phiHxx5Z4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101223224057.3da60db3.sfr@canb.auug.org.au>
References: <20101223224057.3da60db3.sfr@canb.auug.org.au>
Date: Thu, 23 Dec 2010 14:13:01 +0100
Message-ID: <AANLkTimj95TwJ-jLPBQFCdnT1j3wzzzVzLbfxa9YFK47@mail.gmail.com>
Subject: Re: linux-next: No tree for December 23
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:40 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Christmas has intervened!  Today's linux-next (I was putting it together
> in my spare moments) took too long, so it is not being released, sorry.
>
> The next release of linux-next will be Dec 27, or 28 (my time).  Have a
> nice break and relax.  :-)
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Personally, I have no problems w/o a linux-next (next-20101223)
release for today.

Today, you posted a lot of emails with merge problems from diverse
trees, beginning with vfs-scale-working.

Last night, I tried to merge rest-of-Linux-2.6.37-rc7 on top of
linux-next (next-20101221), fixed the conflicts manually.
Then I tried to pull-in vfs-scale-working and I guess I have solved
the merge-problems correct, but my build had several errors.
So, I need more exercise :-).

Now, to my questions:

[1] Linux-next tree as base?

Why are all those for-next/linux-next sub-trees not based/rebased on
linux-next and prepared for you as *the* main co-ordinator of
linux-next?

Funny, there are strange names around like "test" for linux-acpi-2.6
for example - is this a "for-next" tree or not?
I mean the nomenclature seems not to be consistent when I look over
the sub-tress.
Then submaintainers have branches like (what I prefer) "for-linus"
(aka upstream, for-2.6.37) or mostly "for-next" (or "linux-next", aka
for-2.6.38) within a single (same) GIT repository.
Others prefer two separated repos: For example net-2.6 ->
upstream/for-2.6.37 and net-next-2.6 -> linux-next/for-2.6.38.
Surely, it depends on the sub-tree and the interaction with other sub-trees.

Can't all submaintainers use "for-linus" (upstream-fixes) and
"for-next" (new code for upcoming release)?

That's leading to my next question: Ideal/optimal work-flow in merging
tress on top of "parent".

Here an example for a "wise" dependency chain for pulls/merges:
1. net-2.6 -> 2. wireless-2.6 -> 3. net-next-2.6 -> 4. wireless-next-2.6

So John Linville (maintainer of linux-wireless) and Dave Miller
(maintainer of net-2.6) are really working together (I missed that
John also pulls in bluetooth sub-tree). The work (pull-requests) are
documented by emails to both MLs.

For me, it seemd other sub-trees which interact or overlap are not
well co-ordinated (I have block-2.6, vfs-2.6 and *-fs in mind)
So, this needs a bit of an analysis/discussion which would help to
reduce this merge f-ups (I hope).

[2] Merge process?

Is this a script you are using? Is there a standard work-flow you
follow? tree1, then tree2, then tree3... Is this always the same
procedure? Does a script exist or you do that manually? Do you use
"brain-power" or which strategies do you perform to solve merge
conflicts? Which help can give git tool on this?

My 0.02EUR.

- Sedat -
