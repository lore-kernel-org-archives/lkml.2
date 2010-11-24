Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0KXSXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:23:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48692 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab0KXSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:23:14 -0500
Date: Wed, 24 Nov 2010 19:22:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, lib: Add a wbinvd helper for an arbitrary cpu
 set
Message-ID: <20101124182252.GI24892@aftab>
References: <1290620644-27423-1-git-send-email-bp@amd64.org>
 <4CED5012.6040808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED5012.6040808@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 12:49:06PM -0500, H. Peter Anvin wrote:
> On 11/24/2010 09:44 AM, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add a wbinvd helper for an arbitrary set of CPUs.
> > 
> 
> Are there any expected users of this other than KVM?

Not that I know of. I had an earlier version for kvm which did

for_each_cpu(cpu, mask)
	wbinvd_on_cpu(cpu)


but decided to add wbinvd_on_cpus() for completeness. Let me know what
your preference is.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
