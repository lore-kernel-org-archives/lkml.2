Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1KVMO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:14:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56222 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab1KVMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:14:27 -0500
Date: Tue, 22 Nov 2011 12:14:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Oleg Strikov <OSTRIKOV@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111122121422.GN20518@mudshark.cambridge.arm.com>
References: <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
 <20111121203145.GA7301@mudshark.cambridge.arm.com>
 <1321907755.28118.30.camel@twins>
 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
 <20111122114700.GJ20518@mudshark.cambridge.arm.com>
 <68B2676CBD57C643A577008EC1419ED1504663E239@DEMAIL01.nvidia.com>
 <20111122115221.GL20518@mudshark.cambridge.arm.com>
 <68B2676CBD57C643A577008EC1419ED15046778919@DEMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68B2676CBD57C643A577008EC1419ED15046778919@DEMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:00:33PM +0000, Oleg Strikov wrote:
> Also, please do not forget that enabling the userspace access to the counters may not only create some problems
> to the profilers like Perf/OProfile but could also trash the kernel with the interrupts.

Actually, the registers for controlling interrupts aren't visible to
userspace with ARMv7. On ARMv6, this is a different story, which is why I
didn't mention doing this for older platforms earlier :)

Anyway, this thread has digressed now so you can always jump onto the ARM
list (linux-arm-kernel) if you want to discuss this more.

Cheers,

Will
