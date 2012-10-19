Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab2JSWPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:15:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933002Ab2JSWPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:15:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
Date: Sat, 20 Oct 2012 00:19:40 +0200
Message-ID: <5450043.aKImp0J8nh@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5081A3BC.9050201@gmx.net>
References: <50158321.4030007@gmx.net> <201209182342.30244.rjw@sisk.pl> <5081A3BC.9050201@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 of October 2012 21:02:20 Witold Szczeponik wrote:
> On 18/09/12 23:42, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > On Sunday, September 16, 2012, Witold Szczeponik wrote:
> >> Hi Rafael, 
> >>
> >> what about the patches 1 and 3 which do not make any changes to the ABI?
> >> The first patch simplifies the code, while the third patch fixes a problem in
> >> the PNP resource allocation.  Any chances to have them included in 3.7?
> > 
> > They would be fine as far as I'm concerned, but I'm not maintaining that part
> > of the kernel (at least at the moment).
> > 
> > I'm not sure who's the maintainer of it, to be honest.
> 
> Well, according to https://lkml.org/lkml/2012/10/19/375, that would be you
> (together with Bjorn and Len).  :-)  Hence I am resending the request for
> inclusion to you as well.  PNP code went, if I am not mistaken, traditionally
> through Len's tree.  

OK, so can you please resend them?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
