Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1BBMMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:12:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab1BBMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:12:15 -0500
Date: Wed, 2 Feb 2011 12:11:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
Message-ID: <20110202121147.GA24993@n2100.arm.linux.org.uk>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com> <1296470024-26854-2-git-send-email-ohad@wizery.com> <20110131153831.dca62146.akpm@linux-foundation.org> <AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com> <20110131223859.27169db0.akpm@linux-foundation.org> <AANLkTinJLAT0B61Eu1Chn9k9rmbHXa1ZNcedo_m8TZp3@mail.gmail.com> <20110131234028.8744b5fd.akpm@linux-foundation.org> <AANLkTi=zOO_vDQ4+LWQs38xjo+VaRG0jfgo6ifvh=L-M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=zOO_vDQ4+LWQs38xjo+VaRG0jfgo6ifvh=L-M@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:12:38AM +0200, Ohad Ben-Cohen wrote:
> On Tue, Feb 1, 2011 at 9:40 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 1 Feb 2011 09:36:22 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
> >
> >> On Tue, Feb 1, 2011 at 8:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> >> I'll do a quick respin of the patches with that and the
> >> >> hwspinlock_internal.h comment above.
> >> >
> >> > OK..
> >> >
> >> > The patch series looks OK to me.
> >>
> >> Can I add your Acked-by on the non-omap parts when I respin the series ?
> >
> > spose so.  I don't normally do acked-by's.  I think it's my way of
> > avoiding getting blamed when it all blows up.
> 
> I don't want to be breaking old habits then :)
> 
> >> > Maybe Tony or Russell or Greg can grab them
> >> > if they like the look of it all?
> 
> Let's just wait a bit for Tony's or Russell's or Greg's answer.

As it touches OMAP code, it makes sense to merge it through Tony's tree
as that should reduce the number of possible conflicts.
