Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1AEKYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:24:50 -0500
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.218]:21446 "HELO
	nm20-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751692Ab1AEKYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:24:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 646734.43939.bm@omp1008.mail.sp2.yahoo.com
Message-ID: <232289.97320.qm@web113301.mail.gq1.yahoo.com>
X-YMail-OSG: S2BRAKEVM1mZzFiuy6KDoX6dZaCQc0kNXLX8tTAeFPykg3b
 SNRimYs0Ju_OPS8LGBYN52h9N1awYs8He3YH80ffnANepjTf_NhVAU0ir8K9
 CGhwkTgZ9ErzYrGqoIF7oux75LdZUTmMpmpAba7BsCNpezacYIgwf2rKmeqr
 vQXKivhOndhjI20RZTqnC8r4r_Cv8r2qKDGZuCfQMeR3WODfotcwLj8JsmGm
 V.e5Gm70tDFL_uKmT1fianjxmorJ3nPPZcZuI03kIt2VkxWAYbiofAqSDdH9
 xAd5EXJ4p6X.5DIwCK1J..wtWyvIdzUfi.8FKS4gf0o0b9RlOQT0tDmPbW5F
 MdhZ0Jj6gM4eyE.pQe55RAZB3za4n.swRmO6iOsZMSoWIxUCsHaOQ
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
References: <20110104055900.GA5062@bicker> <1294124330.6617.15.camel@Joe-Laptop> <20110104092431.GB1886@bicker>
Date: Wed, 5 Jan 2011 02:24:46 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
To: Dan Carpenter <error27@gmail.com>, Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20110104092431.GB1886@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Dan Carpenter <error27@gmail.com>
> To: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>; linux-kernel@vger.kernel.org; 
>kernel-janitors@vger.kernel.org
> Sent: Tue, January 4, 2011 10:24:31 AM
> Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
> 
> On Mon, Jan 03, 2011 at 10:58:50PM -0800, Joe Perches wrote:
> > On Tue,  2011-01-04 at 08:59 +0300, Dan Carpenter wrote:
> > > +             WARN("put the && or || at the end  of the previous line\n" . 
>$herecurr);
> > 
> > I've submitted something  like this a couple of times and gotten
> > various objections but I think  it's sensible.
> > 
> > https://lkml.org/lkml/2009/12/5/65
> > https://lkml.org/lkml/2010/7/11/92
> 
> If everyone except you thinks  it's a waste of time, then stop asking me
> to redo my patches.  :/   I don't care either way so long as CodingStyle
> and checkpatch reflect the  rules.
> 

 The problem is that CodingStyle (here and elsewhere) is viewed a the holy-grail 
or at least natural-law by some. It should not. It is just about style/taste and 
that will never suit everybody. Insisting to much on style is just driving those 
away that:

a) just want to contribute content
b1) have their own style for decades
b2) detest uniformity

 For *me* the sensible thing is to keep "style" when you make small 
modifications/patches to existing stuff, but use whatever style is best for you 
when contributing new stuff.

 Anyway, I just wanted to say "Happy New Year" to Linux :-)

Cheers
Martin
