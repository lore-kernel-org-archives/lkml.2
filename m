Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2KUPwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:52:25 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:59129 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754956Ab2KUPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:52:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lCaWupS8I7//MZg2ttOAvi9lB34ZYYWo=
Date: Wed, 21 Nov 2012 10:52:08 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
Message-ID: <20121121155208.GF22106@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
 <50ACAAF5.2030002@gmail.com>
 <CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, Nov 21, 2012 at 03:45:42PM +0100, Linus Walleij wrote:
> On Wed, Nov 21, 2012 at 11:20 AM, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> > On 11/21/2012 10:59 AM, Linus Walleij wrote:
> >> On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>  wrote:
> >>> This patch relies on a patch set for mvebu pinctrl taken through
> >>> Linus' pinctrl branch. As there is no other platform than Dove
> >>> involved, I suggest to take it though Jason's tree to avoid any
> >>> further conflicts.
> >>
> >> Sounds like a plan. So you have some commit history pulled
> >> in from the pinctrl tree in the MVEBU tree?
> >
> > I am referring to patches for a pinctrl/mvebu subfolder. IIRC Thomas
> > posted that patch a while ago. Jason is currently sorting things out
> > for mvebu pull requests. I guess both can comment on your question,
> > as I don't fully understand it.
> 
> So what I mean is that the patches creating pinctrl/mvebu is in the
> pinctrl tree, so if patches in the MVEBU tree depend on these,
> then it must have pulled in a branch from pinctrl or applied the
> same patches in that tree too (which is OK *sometimes*).

Yes, Thomas and Gregory informed me of the pinctrl dependency and said
they were using for-next from the pinctrl tree.  I've used that branch
to merge and build successfully.  Is that ok in practice or is there a
more specific branch I should pull in as a dependency?

thx,

Jason.
