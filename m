Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966184Ab2DLVws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:52:48 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4049 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966119Ab2DLVwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:52:23 -0400
Message-ID: <1334267535.11580.1.camel@x61.thuisdomein>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Date: Thu, 12 Apr 2012 23:52:15 +0200
In-Reply-To: <alpine.LFD.2.02.1204121904550.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
	  <20120402235412.GD16303@tassilo.jf.intel.com>
	  <alpine.LFD.2.02.1204031001510.2542@ionos>
	  <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
	  <alpine.LFD.2.02.1204121055200.2542@ionos>
	 <1334230976.1913.9.camel@x61.thuisdomein>
	 <alpine.LFD.2.02.1204121904550.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Apr 2012 21:52:16.0164 (UTC) FILETIME=[86872E40:01CD18F6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 19:06 +0200, Thomas Gleixner wrote:
> Does the test patch I sent solve the problem for you as well?
> 
> See: https://lkml.org/lkml/2012/4/3/88

Yes, it also solves the problem on my laptop.


Paul Bolle

