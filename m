Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2L1Luv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:50:51 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:33435
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab2L1Lut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:50:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dh177df4h17326ahz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 28 Dec 2012 19:50:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20121228115022.GA28009@S2101-09.ap.freescale.net>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
 <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk>
 <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
 <20121227045301.GB17472@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121227045301.GB17472@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 05:53:01AM +0100, Borislav Petkov wrote:
> On Wed, Dec 26, 2012 at 01:09:51PM -0500, Sasha Levin wrote:
> > > This patch can fix the following warning we saw?
> > > http://lkml.org/lkml/2012/12/22/53
> > >
> > > I will give it a try.
> > 
> > Yup, that's the same error I've reported couple of months ago.
> > 
> > It looks like the fb maintains are still absent, so it'll probably
> > need a different way to get upstream.
> 
> Adding to the bug pressure: just got a very similar splat on -rc1 (see
> below). Alan, I'll run your patch to verify.
> 
+1

http://thread.gmane.org/gmane.linux.kernel/1413953/focus=1415070

Shawn

