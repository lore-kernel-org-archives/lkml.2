Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1DHJMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:12:17 -0400
Received: from david.siemens.de ([192.35.17.14]:21100 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1DHJMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:12:16 -0400
Message-ID: <4D9ED146.7040004@siemens.com>
Date: Fri, 08 Apr 2011 11:11:34 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "asias.hejun@gmail.com" <asias.hejun@gmail.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	 <4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>	 <4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>	 <4D9E6F6E.9050709@codemonkey.ws>	 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>	 <4D9EBBC3.2040803@siemens.com> <1302251236.27918.31.camel@jaguar>
In-Reply-To: <1302251236.27918.31.camel@jaguar>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-08 10:27, Pekka Enberg wrote:
> Hi Jan,
> 
> On Fri, 2011-04-08 at 09:39 +0200, Jan Kiszka wrote:
>> I agree that it's easy to change 2kSomething LOC for this. But if you
>> now wait too long designing in essential features like SMP, a scalable
>> execution model, and - very important - portability (*), it can get
>> fairly painful to fix such architectural deficits later on. How long did
>> it take for Linux to overcome the BKL? QEMU is in the same unfortunate
>> position.
> 
> Yup, and we're taking your feedback seriously (and are thankful for
> it!). We're hoping to look at SMP in the near future - help is
> appreciated!

Honestly, I do not yet see a major advantage for us to invest here
instead of / in addition to continuing to improve QEMU. We've spend
quite some effort on the latter with IMO noteworthy results. Porting
over qemu-kvm to upstream was and still is among those efforts. We (*)
are "almost done". :)

Just one example: Despite QEMU's current deficits, I just have add a
handful of (ad-hoc) patches to turn it into a (soft) real-time
hypervisor, and that also for certain non-Linux guests. Your approach is
yet man years of development and stabilization effort away from getting
close to such a level.

Don't want to discourage you or other contributors. I wish you that this
approach can gather the critical mass and momentum to make it a real
alternative, at least for a subset of use cases. We will surely keep an
eye on it and re-assess its pros&cons as it progresses.

Jan

(*) the QEMU & KVM community

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
