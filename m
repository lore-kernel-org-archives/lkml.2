Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1KVLyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:54:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594Ab1KVLyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:54:09 -0500
Date: Tue, 22 Nov 2011 11:54:08 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        "ostrikov@nvidia.com" <ostrikov@nvidia.com>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111122115407.GM20518@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
 <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
 <20111121203145.GA7301@mudshark.cambridge.arm.com>
 <1321907755.28118.30.camel@twins>
 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
 <20111122114700.GJ20518@mudshark.cambridge.arm.com>
 <1321962710.5148.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321962710.5148.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:51:50AM +0000, Peter Zijlstra wrote:
> On Tue, 2011-11-22 at 11:47 +0000, Will Deacon wrote:
> 
> OK, I had interpreted your "we don't always have" to be slightly more
> common than just A15.

It was introduced for v7.1, of which the A15 is the first implementation. A7
and future cores should also have it (it's part of the architected timers
which are really needed for doing virtualisation properly).

Will
