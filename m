Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2DRLHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:07:32 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3657 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344Ab2DRLHb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:07:31 -0400
Message-ID: <1334747246.3755.3.camel@x61.thuisdomein>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 18 Apr 2012 13:07:26 +0200
In-Reply-To: <alpine.LFD.2.02.1204181216380.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
	  <20120402235412.GD16303@tassilo.jf.intel.com>
	  <alpine.LFD.2.02.1204031001510.2542@ionos>
	  <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
	  <alpine.LFD.2.02.1204121055200.2542@ionos>
	  <20120412142904.GA4130@srcf.ucam.org>
	  <alpine.LFD.2.02.1204121903250.2542@ionos>
	  <alpine.LFD.2.02.1204121907330.2542@ionos>
	  <4F872C7B.6000106@linux.intel.com>
	  <alpine.LFD.2.02.1204122241460.2542@ionos>
	 <1334741105.1924.5.camel@x61.thuisdomein>
	 <alpine.LFD.2.02.1204181216380.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-OriginalArrivalTime: 18 Apr 2012 11:07:26.0194 (UTC) FILETIME=[6FFCC520:01CD1D53]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 12:29 +0200, Thomas Gleixner wrote:
> Subject: ACPI: Revert 6fe0d06 ("ACPI: Make ACPI interrupt threaded")
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Paul bisected this regression to 6fe0d06 ("ACPI: Make ACPI interrupt
> threaded"). 
> 
> [...]
>
> Bisected-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Please do s/Paul/Jörg/ and s/Paul Bolle <pebolle@tiscali.nl>/Jörg Otte
<jrg.otte@googlemail.com>/. Jörg did all that work! I just provided some
extra information that apparently wasn't really needed anymore.


Paul Bolle

