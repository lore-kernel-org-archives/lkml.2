Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2HVRox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:44:53 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:25972 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2HVRov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:44:51 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 13:44:51 EDT
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ingo Molnar <mingo@kernel.org>, Ido Yariv <ido@wizery.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 22 Aug 2012 13:39:34 -0400
Subject: RE: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Thread-Topic: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
Thread-Index: Ac2AjN60nrhbZ5BhSvWalfrR1MvkYAAAA/wA
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317F3897AEC7@VMBX108.ihostexchange.net>
References: <20120822100845.GB26323@gmail.com>
 <1345634411-28108-1-git-send-email-ido@wizery.com>
 <20120822173752.GA32500@gmail.com>
In-Reply-To: <20120822173752.GA32500@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

CONFIG_X86_VSMP is only for setting cache-line size to 4KB.    Rest of the bits were never depended on this.

Regards,

--Shai 


> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Wednesday, August 22, 2012 20:38
> To: Ido Yariv
> Cc: linux-kernel@vger.kernel.org; Thomas Gleixner; H. Peter Anvin; Shai
> Fultheim (Shai@ScaleMP.com)
> Subject: Re: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization
> 
> 
> * Ido Yariv <ido@wizery.com> wrote:
> 
> > +#ifdef CONFIG_X86_64
> > +	&x86_hyper_vsmp,
> > +#endif
> 
> Why doesn't it all depend on CONFIG_X86_VSMP?
> 
> Thanks,
> 
> 	Ingo
