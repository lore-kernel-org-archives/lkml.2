Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab0JAWDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:03:44 -0400
Received: from mail.lixom.net ([70.86.134.90]:53319 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0JAWDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:03:43 -0400
Date: Fri, 1 Oct 2010 17:03:43 -0500
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Introduce support for little endian PowerPC
Message-ID: <20101001220343.GA10494@lixom.net>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org> <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com> <1285935283.2463.78.camel@pasglop> <BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org> <1285966315.2463.141.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285966315.2463.141.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 06:51:55AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-10-01 at 12:59 -0500, Kumar Gala wrote:
> > I'm not against it, and I agree some of the patches seem like good
> > clean up.  I'm concerned about this bit rotting pretty quickly.
> 
> Maybe. Most of it doesn't seem to be that bit-rottable.
> 
> The changes to the asm stuff in misc_32.S for example are functions we
> never ever touch once written (libgcc replacements) so I don't see them
> rotting more with LE support than they did with BE :-)

Does KVM/qemu support running LE guest on BE host? That'd help keeping
the bitrot lower. :)



-Olof
