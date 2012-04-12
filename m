Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2DLRGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:06:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:37725 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2DLRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:06:53 -0400
Date: Thu, 12 Apr 2012 19:06:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <1334230976.1913.9.camel@x61.thuisdomein>
Message-ID: <alpine.LFD.2.02.1204121904550.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>  <20120402235412.GD16303@tassilo.jf.intel.com>  <alpine.LFD.2.02.1204031001510.2542@ionos>  <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com> 
 <alpine.LFD.2.02.1204121055200.2542@ionos> <1334230976.1913.9.camel@x61.thuisdomein>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Paul Bolle wrote:
> 3) Feel free to ask for more information.

Does the test patch I sent solve the problem for you as well?

See: https://lkml.org/lkml/2012/4/3/88

Thanks,

	tglx
