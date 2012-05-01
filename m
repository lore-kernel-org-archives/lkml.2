Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2EAPb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:31:28 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:6210 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751928Ab2EAPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:31:27 -0400
Date: Tue, 1 May 2012 11:31:23 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Maarten Maathuis <madman2003@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120501153123.GA17225@elliptictech.com>
References: <20120425013537.GA11959@elliptictech.com>
 <1335322574.1821.8.camel@nisroch>
 <1335504021.5311.0.camel@nisroch>
 <20120428003928.GA16805@elliptictech.com>
 <CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
 <20120428153350.GA19561@elliptictech.com>
 <20120429223744.GA19382@core.coreip.homeip.net>
 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
 <20120501132352.GA28696@elliptictech.com>
 <20120501160930.2f81538c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501160930.2f81538c@pyramind.ukuu.org.uk>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-01 16:09 +0100, Alan Cox wrote:
> > OK, this time bisecting started off relatively smoothly (doing the same
> > "backwards" bisect on the branch-o-reverts as last time), but then my
> > disk died halfway through...  So I'll post the partial bisection results
> > now (11 commits left to test), but I clearly have other things to fix
> > before I can get back to this issue.
> 
> You may get stupid answers because of
> 
> commit eeefa4bea1af34207c5299f989fffe03628ea164
> commit 8353e6c632aeaea1470a286b83e68ca233073068
> 
> Been there, trying to chase down a GMA500 problemt that was muddled in
> with the broken edid.h patch as well as a driver bug.

I'm afraid I don't understand.  These commits do not appear to be in
Linus' tree?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

