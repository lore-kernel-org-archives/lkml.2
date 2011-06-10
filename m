Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1FJRz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:55:27 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:49363 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757087Ab1FJRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:55:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Wa3K/blZ+2WIx4bDQt3e1fE0/zgPDr2j0ya2o0BPISZVdQv/W6a6m41zR0ylloDVV7gpSGrQXEU8VmmWn7Q/ZyeTrgqSmJ+cIFTFgdrSKL44y8RpeYM3VbAFU3zMxhFH;
Date: Fri, 10 Jun 2011 10:55:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, Maxin B John <maxin.john@gmail.com>,
        <linux-doc@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update kmemleak architecture support
 info
Message-Id: <20110610105521.029ae1c3.rdunlap@xenotime.net>
In-Reply-To: <20110610145518.GD18133@e102109-lin.cambridge.arm.com>
References: <20110610070937.GA2802@maxin>
	<4DF1C55A.2080803@ixiacom.com>
	<20110610145518.GD18133@e102109-lin.cambridge.arm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 15:55:18 +0100 Catalin Marinas wrote:

> On Fri, Jun 10, 2011 at 08:18:50AM +0100, Daniel Baluta wrote:
> > On 06/10/2011 10:09 AM, Maxin B John wrote:
> > > -Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> > > +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
> > > +s390 and mips.Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
> > > +for supported platforms.
> > The point of adding my generic comment was to remove direct
> > references to supported platforms.
> > 
> > In this case your patch should remove the line specifying supported
> > platforms (x86, arm, powerpc, etc) and only add the line pointing
> > the reader to lib/Kconfig.debug.
> > 
> > When a new platform will be supported lib/Kconfig.debug will
> > be surely modified, and the change will be consistent with
> > information in kmemleak.txt.
> 
> I think Daniel's suggestion is better, we don't have to worry about
> changing the documentation every time we add a new architecture.
> 
> In addition to that, I would say "supported architectures" rather than
> platforms.

Maxin,

Please send an updated patch without the currently-supported list
of architectures.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
