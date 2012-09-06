Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2IFVR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:17:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759866Ab2IFVRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:17:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: linux-next: Tree for Sept 6 (does not boot on AMD64)
Date: Thu, 6 Sep 2012 23:24:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Andre Przywara <andre.przywara@amd.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>
References: <CA+icZUWgPV=RnXGT4hDsk3xDm8iBu8ShvFFrs=t3+3D3=-bP2Q@mail.gmail.com> <201209062317.53214.rjw@sisk.pl> <CA+icZUW_wkFA5giQGWeVypMtD3coT8FBwzZ6bNSEOvfasCAF_g@mail.gmail.com>
In-Reply-To: <CA+icZUW_wkFA5giQGWeVypMtD3coT8FBwzZ6bNSEOvfasCAF_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209062324.15297.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 06, 2012, Sedat Dilek wrote:
> On Thu, Sep 6, 2012 at 11:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, September 06, 2012, Sedat Dilek wrote:
[...]
> >>
> >> Just wondering... Fell over it when digging into my boot-problem (this
> >> appeared as a new Kconfig option, so).
> >> Thanks for the explanations!
> >
> > Ah, OK.  I got the impression that the patchset caused a problem to happen for
> > you.  I suppose it's fine to keep it in linux-next after all, then?
> >
> 
> Please, keep it!
> My system boots with the slab-next-fixes!
> My apologies for my curiosity - asking should be allowed, anyway :-).

Sure, no problem with that.  Thanks for the clarification.

Rafael
