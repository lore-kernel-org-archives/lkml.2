Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0JHKVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:21:23 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25695 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab0JHKVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:21:22 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zzbb2cK1432N98dN179dN9371Pzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9YVFD-02-DUV-02
X-M-MSG: 
Date: Fri, 8 Oct 2010 12:21:15 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] apic, x86: Use BIOS settings for IBS and MCE
 threshold interrupt LVT offsets
Message-ID: <20101008102115.GG13563@erda.amd.com>
References: <1286360874-1471-1-git-send-email-robert.richter@amd.com>
 <1286360874-1471-3-git-send-email-robert.richter@amd.com>
 <20101006194150.GA17647@lenovo>
 <20101008092452.GE13563@erda.amd.com>
 <AANLkTi=6O1nUC71OiwcJBjmH-naq3ofMXyA0BqoT7Q55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTi=6O1nUC71OiwcJBjmH-naq3ofMXyA0BqoT7Q55@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.10 05:37:24, Cyrill Gorcunov wrote:
> On Fri, Oct 8, 2010 at 1:24 PM, Robert Richter <robert.richter@amd.com> wrote:
> ...
> >> > +                   } else if (lvt_off != offset) {
> >>
> >> Could we put explicit type specificator here? For better readbility.
> >> ...
> >
> > Cyrill,
> >
> > Do you mean an explicit type cast here, or something else?
> >
> 
> Yeah, explicit type cast (not a big deal though since at moment
> of course nothing can fire in this snippet, but I think for future
> modifications better to have explicit cast).

Hmm, don't think this is really necessary. As an alternative we could
make variable offset an int too and then do an explicit cast when
calling setup_APIC_eilvt().

But I rather tend to leave it as it is.

-Robert

> 
> >
> > Thanks for review,
> >
> > -Robert
> >
> 
> Cyrill
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

