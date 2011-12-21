Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1LUKmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:42:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39385 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1LUKmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:42:11 -0500
MIME-Version: 1.0
In-Reply-To: <4EF1B423.8050707@siemens.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com>
 <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com>
 <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com>
 <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Wed, 21 Dec 2011 12:41:50 +0200
Message-ID: <CAB9v_DFheyv6rnTSk90=v-Gnc-zVy7d_8mPab4wXCAnEp0VL+A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Liu, Jinsong" <jinsong.liu@intel.com>, Avi Kivity <avi@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 12:25, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> We must not report the TSC deadline timer feature on our own when user
> space provides the APIC as we have no clue about its features.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>
> Changes in v2:
>  - reorganized code to make the flow clearer

I've seen Avi's comment below, but just for the note, it works fine
when applied to arch/x86/kvm/x86.c.
