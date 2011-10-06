Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab1JFQCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:02:18 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:42080 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046Ab1JFQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:02:17 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: Valdis.Kletnieks@vt.edu
Cc: Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
In-Reply-To: <34045.1317760188@turing-police.cc.vt.edu>
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl>
	 <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
	 <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi>
	 <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi>
	 <34045.1317760188@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 06 Oct 2011 11:58:22 -0400
Message-ID: <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: kernel.org status: establishing a PGP web of trust
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 16:29 -0400, Valdis.Kletnieks@vt.edu wrote:
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

Exactly. This is why we really need to get over the stupidity of turning
up to keysigning parties and looking at passports from countries we've
never been to as if we could really even tell they weren't freshly
printed. I know I wouldn't know what a Russian passport is supposed to
look like, even though I've seen many apparently from that country.

What I'd like to see is "keysigning" parties where folks with well
established (in use) keys turn up and *prove* they own the key by
signing some information the other attendees provide. That way they can
not only say "hey, I'm dude X, trust me this is my fingerprint, here's a
photo ID" (which means nothing in the case of a well established online
identify that is trusted already), but they can say "hey, I have access
to this key, because I just signed that random message you gave me
interactively". Who cares who the heck they really are beyond that?
(intentionally a loaded statement to make the point).

Jon.


