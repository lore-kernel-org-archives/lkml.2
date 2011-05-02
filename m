Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1EBHpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 03:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1EBHpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 03:45:41 -0400
Date: Mon, 2 May 2011 10:45:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
Message-ID: <20110502074524.GD18376@redhat.com>
References: <20110430171459.685415696@openvz.org>
 <4DBC6DC1.30900@redhat.com>
 <20110501164635.GA21833@elte.hu>
 <BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>
 <20110502053928.GB18376@redhat.com>
 <BANLkTi=Bw5k1_oytZmXgTrQ-XUJisp3vfQ@mail.gmail.com>
 <4DBE589C.1040103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBE589C.1040103@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 11:09:16AM +0400, Cyrill Gorcunov wrote:
> On 05/02/2011 09:51 AM, Cyrill Gorcunov wrote:
> > Yeah, i'll do so as only bring my laptop to life, I managed to kill
> > grub and can't restore it back for a while, will ping you back as soon
> > as I can.
> > 
> > Sorry for top post.
> > 
> 
>   I've managed to semi-restore it. Gleb, maybe there some additional
> parameter needed for kvm (except -cpu host,+x2apic) to make it work
> with cluster mode? I always see physical mode which was not the target
> of the patch series.
> 
Hmm, +x2apic is enough to advertise x2apic presents to the OS. What
logic Linux uses to decide which mode to use?

--
			Gleb.
