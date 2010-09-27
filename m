Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645Ab0I0P0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:26:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48249 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759609Ab0I0P0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:26:31 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Sep 2010 20:56:13 +0530
Subject: RE: drivers:staging:ti-st: merge issues.
Thread-Topic: drivers:staging:ti-st: merge issues.
Thread-Index: ActcUkUTRf2m3muEQKS6sPdGMzCpkgCBfJ1Q
Message-ID: <19F8576C6E063C45BE387C64729E739404A9D8A4B4@dbde02.ent.ti.com>
References: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
	<20100924193027.GA17728@suse.de>
 <20100925113743.f1e31a0a.sfr@canb.auug.org.au>
In-Reply-To: <20100925113743.f1e31a0a.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, Greg,



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Friday, September 24, 2010 8:38 PM
> To: Greg KH
> Cc: Savoy, Pavan; linux-kernel@vger.kernel.org
> Subject: Re: drivers:staging:ti-st: merge issues.
> 
> Hi Greg,
> 
> On Fri, 24 Sep 2010 12:30:27 -0700 Greg KH <gregkh@suse.de> wrote:
> >
> > On Fri, Sep 24, 2010 at 02:11:50PM -0500, Pavan Savoy wrote:
> > >
> > > The merges bbf96b3cb54a237f1a66883390637e30bb4407ba and the merge on
> > > 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac has caused the
> > > drivers/staging/ti-st to get corrupted, I had submitted few patches
> > > and it was all merged.
> > >
> > > basically the merge for bbf96b3cb54a237f1a66883390637e30bb4407ba for
> > > drivers/staging/ti-st/ shouldn't have happened.
> > > The head for the drivers/staging/ti-st/ should have been @
> > > 83ef41f0858b48cce4f8ca23f674ec55d50bf47d
> >
> > I have no idea what this all means, sorry.
> 
> I was with you, here (until I looked hard :-().
> 
> > Are these linux-next merges?
> 
> bbf96b3cb54a237f1a66883390637e30bb4407ba is the merge of the staging-next
> tree into linux-next. 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac is the
> patch "Staging: ti-st: remove st_get_plat_device" that is in
> staging.current (and also in staging-next as commmit
> dbd3a8709560365ff9b1e5eca263f608877a8a89).
> 83ef41f0858b48cce4f8ca23f674ec55d50bf47d is the commit "staging: ti-st:
> mv headers to ti_wilink_st" that is in the staging-next tree.
> 
> > If I need to apply a patch to the staging-next, or Linus's tree, please
> > let me know.
> >
> > confused,
> 
> I was as well.  All I could guess was that my merge resolution when merging
> the staging-next tree was not correct?  The resolution I did was to remove
> drivers/staging/ti-st/st.h and drivers/staging/ti-st/st_core.h (since
> that had been done in commit 83ef41f0 ("staging: ti-st: mv headers to
> ti_wilink_st") in staging-next) and ...
> 
> (I see it now) I used the wrong version of
> drivers/staging/ti-st/st_kim.c ... Sorry about that.  I will correct that
> merge in the next release of linux-next.

Looks like its all sorted out, Thanks!!

> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
