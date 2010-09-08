Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0IHTw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:52:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0IHTwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TzHD+CESv7RDOhSbpYe45ZIyc3vSXiJp0uNovWb8eoDWVulAAiSubmbxODz6kQJcbj
         8mgw6NB70U0UdKm8gski4hfCPCc9dkrGyIhaQ32l7hjAgQXoPCdtO49ljqsopBjgjd0a
         ch3Su85oNpzVqNxb7xmjm5pt9wZv96nrIYm2I=
Date: Wed, 8 Sep 2010 22:29:23 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100908202923.GA4913@loge.amd.com>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <20100718162239.GA21151@fancy-poultry.org>
 <20100719193454.GB19344@aftab>
 <20100720151405.GA6368@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720151405.GA6368@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 05:14:05PM +0200, Heinz Diehl wrote:
> On 19.07.2010, Borislav Petkov wrote: 
> 
> [Patches]
> > Please boot this on your machine and send me the whole dmesg, as usual.
> 
> Appying these 2 patches to 2.6.35-rc5 didn't help, the machine is stalling
> as usual and several key presses are required to get it to boot.

Can you please boot using acpi_skip_timer_override kernel parameter?
I recently had a chance to test on another Gigabyte mainbaord which
showed similar symptoms as your system. I did not find suspicious
things in HPET or APIC configuration but this kernel option worked
around the problem.

See also https://bugzilla.kernel.org/show_bug.cgi?id=15289


Thanks,

Andreas
