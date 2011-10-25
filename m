Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1JYBK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 21:10:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40783 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756137Ab1JYBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 21:10:58 -0400
Message-ID: <1319505057.2094.35.camel@Joe-Laptop>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
From: Joe Perches <joe@perches.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Date: Mon, 24 Oct 2011 18:10:57 -0700
In-Reply-To: <CAFLxGvw1bmvr-g4Yhu2xtwx0E6tvV0ECvbvvECrpyVHnZB9+Xw@mail.gmail.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	 <1319496149.2094.3.camel@Joe-Laptop> <20111024231829.GB25993@redhat.com>
	 <CAFLxGvw1bmvr-g4Yhu2xtwx0E6tvV0ECvbvvECrpyVHnZB9+Xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 01:24 +0200, richard -rw- weinberger wrote:
> On Tue, Oct 25, 2011 at 1:18 AM, Dave Jones <davej@redhat.com> wrote:
> > On Mon, Oct 24, 2011 at 03:42:29PM -0700, Joe Perches wrote:
> >  > James seems to be uninterested in picking up
> >  > obvious and trivially correct patches.
> >  > >From a year ago...
> >  > https://lkml.org/lkml/2010/10/31/123
> >  > James?
> > That's just ridiculous.
> > If maintainers aren't picking up obviously correct fixes[*], just send
> > them directly to Linus or Andrew.
> Or resend the patch.

I resent it too.

> Sometimes maintainers are quite busy and overlook a patch...

Or are perhaps just uninterested.


