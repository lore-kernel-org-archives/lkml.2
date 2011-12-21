Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1LUMCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab1LUMCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:02:48 -0500
Message-ID: <4EF1CAE0.2070609@redhat.com>
Date: Wed, 21 Dec 2011 14:02:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com> <4EF1B7C0.3080200@siemens.com> <4EF1B8A4.2050008@redhat.com> <4EF1C2DD.8070303@siemens.com> <4EF1C6C5.6080300@redhat.com> <4EF1C9E9.50805@siemens.com>
In-Reply-To: <4EF1C9E9.50805@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 01:58 PM, Jan Kiszka wrote:
> > +1
>
> Ah, the adult crowd that trusts the other side.

It's 80% gnome-shell rants and similar, don't bother.

> OK, will see that I can cook up a proper patch later.
>

Thanks.

-- 
error compiling committee.c: too many arguments to function

