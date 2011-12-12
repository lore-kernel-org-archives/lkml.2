Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1LLSRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:17:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1LLSRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:17:12 -0500
Message-ID: <4EE64512.3080709@redhat.com>
Date: Mon, 12 Dec 2011 20:16:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <1323667836.4190.4.camel@lappy> <20111212111222.GA21121@elte.hu> <20111212112052.30a568f7@pyramind.ukuu.org.uk>
In-Reply-To: <20111212112052.30a568f7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:20 PM, Alan Cox wrote:
> > [*] Also, those 10K cycles include some significant Qemu 
> >     overhead - a couple of thousand cycles - that should be much 
> >     lower in the tools/kvm case.
>
> Are all the traps going into qemu

Only the ones that go to devices modelled in userspace.

>  - is KVM still that braindead ?

How would you do it?

-- 
error compiling committee.c: too many arguments to function

