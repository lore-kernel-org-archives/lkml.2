Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1JLUwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:52:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43771 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JLUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:52:34 -0400
Date: Wed, 12 Oct 2011 16:40:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111012204048.GA22260@phenom.oracle.com>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
 <4E94E1E5.4070505@goop.org>
 <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012194543.GD14966@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E95FDB9.0025:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 09:45:43PM +0200, Borislav Petkov wrote:
> On Wed, Oct 12, 2011 at 03:18:22PM -0400, Jeremy Fitzhardinge wrote:
> > While doing the whole boot time multiboot thing may offer some small
> > hypothetical technical advantages, it has the significant cost of just
> > complicating the whole deployment and use story.
> 
> You simply can't call the need to apply ucode as early as possible a
> "hypothetical techical advantage." Other issues like how to handle ucode
> images and how to put them together and how distros distribute them
> and whether xen minimizes the amount of "specialness" or not are only
> secondary.

Why is it paramount to do it as early as possible? As in, even doing
it before Linux kernel is invoked is preferred than during initrd runtime?
