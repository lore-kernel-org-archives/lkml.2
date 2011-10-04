Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab1JDWjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:39:37 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48875 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab1JDWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:39:36 -0400
Date: Wed, 5 Oct 2011 01:39:32 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Valdis.Kletnieks@vt.edu
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111004223932.GA3460@localhost.pp.htv.fi>
References: <4E8655CD.90107@zytor.com>
 <201110020304.28288.rjw@sisk.pl>
 <4E87B885.50005@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <20111003093239.GB25136@localhost.pp.htv.fi>
 <y0mobxyjazi.fsf@fche.csb>
 <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <34045.1317760188@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 04:29:48PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 03 Oct 2011 21:04:41 +0300, Adrian Bunk said:
> > On Mon, Oct 03, 2011 at 12:28:17PM -0400, Frank Ch. Eigler wrote:
> 
> > > What is the threat that this passport checking is intended to cure?
> > > That someone else might have been impersonating Rafael for years,
> > > sending patches, chatting in email and over the phone, and attending
> > > conferences?
> >
> > Key signing is an identity check.
> 
> That's dodging the issue. Somehow, I don't see Andrew Morton asking Linus to
> sign his key, and Linus saying "How do I know you're the *real* Andrew Morton?"
> And Andrew is a clever guy, if he was a fake Andrew, I'm sure he'd have gotten
> a fake ID that would be good enough to fool Linus, who is also a clever guy but
> I'm not aware of any special background he has in forgery detection. ;)
> 
> The more important point is that as far as the linux-kernel community is
> concerned, the guy we've all seen show up at conferences and present stuff all
> these times *is* Andrew Morton, even if his real name is George Q. Smith and
> he's been on the run for the last 27 years for an embarassing incident
> involving an ostrich, the mayor's daughter, and 17 gallons of mineral oil in
> the atrium of the museum. ;)
> 
> The ID check is  to connect an actual person to the claimed key, and primarily
> intended for key signing parties and the like, where people *don't* know each
> other very well. I think there's something like 5 people on the linux-kernel
> list who actually know me in real life, because I don't travel much and I'm
> rather in the boonies.  If I asked anybody *else* who I'd not met before to
> sign my key, yes, I'd expect them to check my ID, to ensure I wasn't somebody
> trying to pull a fast one at the keysigning party.

If you just want to be sure that patch number 100 comes from the same
person as the 99 patches before you could do that without key signing 
(require signed patches and check that all 100 patches were signed by
 the same key).

But the semantics of PGP key signing is that you certify that you 
verified that a photo ID of that person matches the name on the key.

No matter if that's needed for kernel purposes.
And no matter if it's possible to present you a fake ID.

One might discuss what requirements for access to kernel.org machines make 
sense or not, but when you sign a key you have to check a photo ID first.

> > > If so, perhaps the impostor is of more value to the
> > > project than the Real Rafael.
> > 
> > Pseudonymous contributions to the kernel are not allowed.
> 
> See above - whoever Andrew Morton *really* is, his contributions are hardly
> pseudonymous.

Each time a patch goes through him into the kernel, he certifies that 
his real name is Andrew Morton.

If that would not be his real name, it would make him somewhere between 
completely untrustable and punishable at court.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

