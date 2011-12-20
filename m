Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1LTJsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:48:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab1LTJsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:48:18 -0500
Message-ID: <4EF059DA.8070006@redhat.com>
Date: Tue, 20 Dec 2011 11:48:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, bisected] a3e06bbe8445f57eb949e6474c5a9b30f24d2057:
 KVM: emulate lapic tsc deadline timer for guest"
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:26 AM, Liu, Jinsong wrote:
> > 
> > Qemu-kvm is fine for me, but this is a regression and should be fixed.
>
> Sorry, I haven't your environment to debug illumos regression.
> I don't think it directly related to kvm tsc deadline timer, and I think it's no value to do it now, since 
> for linux guest it works fine w/ both qemu & qemu-kvm,
> for illumos guest you just need wait qemu-kvm sync into qemu.

No, we need to understand what's going on here, instead of sweeping it
under the rug.

-- 
error compiling committee.c: too many arguments to function

