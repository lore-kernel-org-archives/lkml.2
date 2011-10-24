Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab1JXXZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 19:25:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1JXXZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 19:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111024231829.GB25993@redhat.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	<1319496149.2094.3.camel@Joe-Laptop>
	<20111024231829.GB25993@redhat.com>
Date: Tue, 25 Oct 2011 01:24:58 +0200
Message-ID: <CAFLxGvw1bmvr-g4Yhu2xtwx0E6tvV0ECvbvvECrpyVHnZB9+Xw@mail.gmail.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dave Jones <davej@redhat.com>, Joe Perches <joe@perches.com>,
        Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 1:18 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Oct 24, 2011 at 03:42:29PM -0700, Joe Perches wrote:
>  > James seems to be uninterested in picking up
>  > obvious and trivially correct patches.
>  >
>  > >From a year ago...
>  >
>  > https://lkml.org/lkml/2010/10/31/123
>  >
>  > James?
>
> That's just ridiculous.
> If maintainers aren't picking up obviously correct fixes[*], just send
> them directly to Linus or Andrew.
>

Or resend the patch.
Sometimes maintainers are quite busy and overlook a patch...

-- 
Thanks,
//richard
