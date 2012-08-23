Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab2HWNcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:32:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab2HWNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:32:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 2/6] ARM: omap: allow building omap44xx without SMP
Date: Thu, 23 Aug 2012 13:32:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <201208231212.04869.arnd@arndb.de> <CAMQu2gzPMkbDvTfTOZVp+Qh=2=AHOuyt4NXtxAps=RmMF+mf6Q@mail.gmail.com>
In-Reply-To: <CAMQu2gzPMkbDvTfTOZVp+Qh=2=AHOuyt4NXtxAps=RmMF+mf6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231332.40530.arnd@arndb.de>
X-Provags-ID: V02:K0:y9M/gBiWp7FS8CueQZJ743He2eoZJSXzm4hwOIQIOn+
 Om/+TSlELio1JA6EJM7+b3EMyfJAlfsbPQpYOvKhHciv/Gr1xs
 Uf+SZiuspcQqOc/7eRshWix2xbFoRkjIzAJR8XEc4ivQ8D2at6
 +6CltBryMYvxEffPUqvbGQ5tfXvbKFASjeeWxn2oScI6wG+lmh
 q5noKeBa2GOoQ+Qm0b/Y8YVdGwMPlFWHYSdZhcUhMUDJXtmLGf
 TrXLY/cAsKXbihdfdrxZvPbHB3Bi5wGN/vQAUXdJhqyCRv462y
 kpmThJq/OeerxpJptTA8wsEBYqyMdtqWXwyeWDmAUVjlR1PSxx
 FIAGV6ccsE/rxhB252Ug=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Shilimkar, Santosh wrote:
> 
> On Thu, Aug 23, 2012 at 5:42 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Thursday 23 August 2012, Shilimkar, Santosh wrote:
> > > I see your point but alternate patch is pushing down the fix to the low
> > > level driver and that means you end up patching more drivers when they
> > > use COUPLE idle infrastructure. That was the only reason I was thinking
> > > of suppressing the error at the source.
> > >
> > > Since it is just for the random builds and actually doesn't impact the
> > > real
> > > functionality as such, I am fine with your proposed patch too.
> >
> > Ok. It would be nice of course to test if this actually works on
> > uniprocessor
> > configurations.
> >
> Have tested the patch and it does boot with UP build on OMAP.
> 
> Acked-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Ok, thanks a lot!

	Arnd
