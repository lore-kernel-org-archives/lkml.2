Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2DRJZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:25:13 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1162 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab2DRJZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:25:11 -0400
Message-ID: <1334741105.1924.5.camel@x61.thuisdomein>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Date: Wed, 18 Apr 2012 11:25:05 +0200
In-Reply-To: <alpine.LFD.2.02.1204122241460.2542@ionos>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 18 Apr 2012 09:25:05.0824 (UTC) FILETIME=[240AAA00:01CD1D45]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 22:42 +0200, Thomas Gleixner wrote:
> > For 3.4 I think reverting is the right approach.
> 
> Ack.

A revert of 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d ("ACPI: Make ACPI
interrupt threaded") wasn't included in v3.4-rc3. Has it been pushed
somewhere? Is testing needed before that revert can be pushed?


Paul Bolle

