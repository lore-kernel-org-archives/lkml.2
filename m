Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1LMOaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:30:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1LMOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:30:19 -0500
Message-ID: <1323786613.3263.13.camel@lappy>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Dec 2011 16:30:13 +0200
In-Reply-To: <4EE75FF8.5060208@redhat.com>
References: <20111210132220.083204833@linutronix.de>
	 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	 <alpine.LFD.2.02.1112102144370.3020@ionos>
	 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	 <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos>
	 <20111211155347.GA1297@elte.hu>
	 <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	 <20111212172059.GC23870@elte.hu>
	 <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
	 <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos>
	 <4EE72FCB.3070109@redhat.com> <alpine.LFD.2.02.1112131434320.3020@ionos>
	 <4EE75FF8.5060208@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 16:23 +0200, Avi Kivity wrote:
> With qemu, -cpu host or -cpu blah,+x2apic.  kvm-tool does the equivalent
> of -cpu host, so I'm surprised it doesn't show up.  x2apic has been
> recognized by the guest for a long time (ce69a784; 2.6.32, I'll be
> surprised if you have anything older than that on your machine).
> 
> Does x2apic show up in your guest's /proc/cpuinfo? 

It should be detected on the guest. kvm tool does currently have an
issue where if x2apic is enabled, MSI-X interrupts will only go to
VCPU#0 (ideas for solving that are welcome).

-- 

Sasha.

