Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1EQMuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:50:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab1EQMup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:50:45 -0400
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1305625748.8008.98.camel@i7.infradead.org>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
	 <1305126431.30435.163.camel@i7.infradead.org>
	 <1305577977.3146.112.camel@x201>
	 <1305625748.8008.98.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 06:50:25 -0600
Message-ID: <1305636625.3146.119.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 10:49 +0100, Woodhouse, David wrote:
> On Mon, 2011-05-16 at 21:32 +0100, Alex Williamson wrote:
> > Just a guess, but the OEM probably hasn't updated their SMI handlers to
> > understand x2apic yet and won't before the product ships because some
> > other OS doesn't bother to use x2apic. 
> 
> Yay, crappy closed-source BIOS holds back the platform yet again.
> 
> >  We can still enable interrupt remapping w/o x2apic though, so I'm
> > curious what other irq injection tricks you're referring to.  Thanks,
> 
> http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf

Yep, I just read that, and while x2apic guarantees that we must turn on
the interrupt remapper and block compatibility format, lack of x2apic
doesn't preclude us from doing the same.  Right?  Thanks,

Alex

