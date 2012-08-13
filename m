Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab2HMOLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:11:30 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:27725
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2HMOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:11:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah)
X-WSS-ID: 0M8P62U-02-MF0-02
X-M-MSG: 
Date: Mon, 13 Aug 2012 09:11:20 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120813141120.GA8441@jshin-Toonie>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-2-git-send-email-jacob.shin@amd.com>
 <CAE9FiQXiSq=5VQ5nNELPjDkj0QRjA=sbKfPwAeVDADteY-vdyw@mail.gmail.com>
 <5026A637.2070104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5026A637.2070104@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 11:36:39AM -0700, H. Peter Anvin wrote:
> On 08/09/2012 03:03 PM, Yinghai Lu wrote:
> >
> >can you put those line in another function?
> >
> >setup_arch is way too big now.
> >
> 
> I agree with this ... Jacob, could you rev the patch?

Yes of course, I'll send out the revised patchset later today,

-Jacob

> 
> 	-hpa
> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

