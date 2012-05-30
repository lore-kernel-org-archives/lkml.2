Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2E3Knh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:43:37 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34940 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2E3Kng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:43:36 -0400
Date: Wed, 30 May 2012 12:44:03 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?M=FCller?= Keve <keve@irb.hu>
Subject: Re: Unhandled IRQs on AMD E-450
Message-ID: <20120530104403.GA4771@aftab.osrc.amd.com>
References: <4F97BA60.4080505@ladisch.de>
 <20120427082203.GB9233@aftab.osrc.amd.com>
 <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>
 <CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>
 <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>
 <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>
 <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
 <20120430102150.GA9303@aftab.osrc.amd.com>
 <alpine.DEB.2.02.1204301332310.14286@zacate>
 <alpine.LFD.2.02.1205300020070.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1205300020070.3231@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:07:20AM +0200, Thomas Gleixner wrote:
> I have no objections to improve the spurious/poll handling but this
> has do be done more carefully.
> 
> Also I'm very interested to figure out the root cause of this problem
> first. You provided quite some information already, but I'm still
> waiting for some more.
> 
> Aside of that it would be helpful if the AMD folks could try to get
> some more information about this issue on the documentation/errata
> level. Boris ???

Hmm,

from reading what people have debugged so far, this looks like a problem
with the Asmedia ASM1083 PCIe-PCI bridge:

http://marc.info/?l=linux-kernel&m=132793745319418

and both Intel and AMD boards which are integrating this thing are
affected.

There's even a great message from Asmedia at the end of the thread, it
is a lot of fun reading.

As always, I'll try to ask around but can't promise anything. We
probably need to get some Intel folk involved too.

@Müller: can you send me the mail address of that Asmedia contact
privately? If ASUS are on CC, them too.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
