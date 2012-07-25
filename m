Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2GYJYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:24:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab2GYJX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:23:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Date: Wed, 25 Jul 2012 11:29:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207241956.06986.arnd@arndb.de> <201207242237.28051.rjw@sisk.pl>
In-Reply-To: <201207242237.28051.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207251129.44930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 24, 2012, Rafael J. Wysocki wrote:
> On Tuesday, July 24, 2012, Arnd Bergmann wrote:
> > On Tuesday 24 July 2012, Rafael J. Wysocki wrote:
> > > On Tuesday, July 24, 2012, Arnd Bergmann wrote:
> > > > On Saturday 21 July 2012, Rafael J. Wysocki wrote:
> > 
> > > > 
> > > > Sorry for taking so long to reply. I am really not that familiar with the
> > > > power domain requirements, but I do have two comments on your approach:
> > > > 
> > > > * I think when we want to add a generic concept to the device tree such
> > > >   as power domains, we should always make it specified in a generic way.
> > > 
> > > Do we really want that?  I'm a bit skeptical, because apparently nobody
> > > cares, as the (zero) response to this patchset evidently indicates and
> > > since nobody cares, it's probably better not to add such "generic" things
> > > just yet.
> > 
> > Well, the trouble with bindings is that they are much harder to change
> > later, at least in incompatible ways. 
> 
> Hmm, so I think you wanted to say that it might be burdensome to retain the
> code handling the old binding once we had started to use a new generic one.
> 
> I can agree with that, but that's quite similar to user space interfaces.
> Once we've exposed a user space interface of some kind and someone starts
> to use it, we'll have to maintain it going forward for the user in question.
> However, there is a way to deprecate old user space interfaces and it has
> happened.
> 
> In this particular case the burden would be on Renesas, but I don't think it
> would affect anybody else.

Whereas, if we go for a generic binding and get it wrong (which is quite
likely, given the general lack of information on what the needs are), we'll
have a much bigger problem that _will_ affect everyone.

So, my opinion is to go for vendor-specific attributes of limited scope for now,
that will be relatively easy to deprecate in the future.

Thanks,
Rafael
