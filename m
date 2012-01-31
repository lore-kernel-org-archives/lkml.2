Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2AaMPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:15:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2AaMPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:15:24 -0500
Date: Tue, 31 Jan 2012 13:15:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        KVM devel mailing list <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [VT-d reboot problems] Re: [PATCH] x86 / reboot: Blacklist Dell
 OptiPlex 990 known to require PCI reboot
Message-ID: <20120131121513.GE32010@elte.hu>
References: <201111160019.51303.rjw@sisk.pl>
 <201201091700.09318.roucaries.bastien@gmail.com>
 <20120116004110.GA21240@srcf.ucam.org>
 <CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
 <4F1478B0.6080200@zytor.com>
 <CAE2SPAak9xnN8Tbjru3eLN79_JGTGaPWi7w+t=7peN-Nd9f+Bw@mail.gmail.com>
 <CAE2SPAbHxjQm3-z+LRXYBJAVnrwjMn=u=9RFLmZ6hkc8XtNy+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE2SPAbHxjQm3-z+LRXYBJAVnrwjMn=u=9RFLmZ6hkc8XtNy+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(added KVM folks to the Cc:)

* Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> Ping^2
> 
> Bastien
> On Mon, Jan 23, 2012 at 11:28 AM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
> > On Mon, Jan 16, 2012 at 8:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> On 01/16/2012 03:27 AM, Bastien ROUCARIES wrote:
> >>>>
> >>>> Does it work if you disable VT-d in the firmware? If so, then adding it
> >>>> to the reboot method blacklist is the wrong fix - we need to figure out
> >>>> why VT-d interferes with Dell's reboot code.
> >>>
> >>> Yes it work
> >>>
> >>
> >> This is particularly so since we are very close to having a full Dell
> >> model catalogue in the kernel...
> >
> > Ping ? Do you need some dump ? testing ?

So disabling VT-d in the BIOS fixes the reboot problem and 
Matthew Garrett suggests we should figure out why and how VT-d 
on this Dell box interferes with the reboot method.

Thanks,

	Ingo
