Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1HVIA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:00:56 -0400
Received: from mailfe05.c2i.net ([212.247.154.130]:58827 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752057Ab1HVIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:00:51 -0400
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.1 cv=b20eX9+WwT+rchjRp65q2r9rWd5NV3fsbYwDDw8k8E8= c=1 sm=1 a=SvYTsOw2Z4kA:10 a=55MoappXO6kA:10 a=WQU8e4WWZSUA:10 a=8nJEP1OIZ-IA:10 a=CL8lFSKtTFcA:10 a=i9M/sDlu2rpZ9XS819oYzg==:17 a=UVu0ioI0mP7kC5JML1EA:9 a=wPNLvfGTeEIA:10 a=i9M/sDlu2rpZ9XS819oYzg==:117
From: Hans Petter Selasky <hselasky@c2i.net>
To: "Amit Blay" <ablay@codeaurora.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Mon, 22 Aug 2011 09:58:21 +0200
User-Agent: KMail/1.13.5 (FreeBSD/8.2-STABLE; KDE/4.4.5; amd64; ; )
Cc: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <20110818224713.GA6738@xanatos> <7e62861a4ff90aa7990dda5563340797.squirrel@www.codeaurora.org>
In-Reply-To: <7e62861a4ff90aa7990dda5563340797.squirrel@www.codeaurora.org>
X-Face: *nPdTl_}RuAI6^PVpA02T?$%Xa^>@hE0uyUIoiha$pC:9TVgl.Oq,NwSZ4V"|LR.+tj}g5
	%V,x^qOs~mnU3]Gn;cQLv&.N>TrxmSFf+p6(30a/{)KUU!s}w\IhQBj}[g}bj0I3^glmC(
	:AuzV9:.hESm-x4h240C`9=w
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220958.21618.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 August 2011 12:18:34 Amit Blay wrote:
> Thanks Sarah, Hans for your comments,
> 
> On Thu, August 18, 2011 3:47 pm, Sarah Sharp wrote:
> > Yes, I think this is the correct solution.  Sorry for taking so long to
> > get back to you.
> 
> OK, so I will go ahead with implementing this solution.
> 
> > On Wed, Aug 17, 2011 at 09:06:03AM +0200, Hans Petter Selasky wrote:
> >> I would suggest overloading the "unsigned int pipe", instead of breaking
> >> existing API's by adding a new stream ID value. Also for LibUSB.
> 
> The purposed solution will not break any existing API, by doing the
> following:
> a. Adding a new API for streams alloc/dealloc
> b. Adding a new API for submitting a URB which is stream capable (I will
> implement this in a separate patch).
> 
> > I don't see this as a strong argument why we should arbitrarily limit a
> > new API.  It's very hard to deprecate kernel to userspace API, so I
> > think we should do it right the first time.  There are current
> > applications (like an SSD behind a UAS device) that need as many
> > concurrent streams in flight as possible, so I don't buy the argument
> > that there aren't current applications that need that many streams.
> 
> I agree with Sarah.
> Hans, I appreciate your inputs. Please let me know if you see a good
> reason why not implementing the new APIs purposed above for streams
> allocation and usage. Otherwise I will go ahead with the implementation.

Hi Amit,

I think your suggestion is OK.

--HPS
