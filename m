Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab1CBACa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:02:30 -0500
Received: from relais.videotron.ca ([24.201.245.36]:45055 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab1CBAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:02:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 01 Mar 2011 19:02:27 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, David Brown <davidb@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
In-reply-to: <4D6D652A.5050502@codeaurora.org>
Message-id: <alpine.LFD.2.00.1103011858370.6799@xanadu.home>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
 <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
 <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
 <4D688AF1.1090607@codeaurora.org>
 <20110226084736.GB3640@n2100.arm.linux.org.uk>
 <8yazkpi3cfa.fsf@huya.qualcomm.com>
 <alpine.LFD.2.00.1102261452340.22034@xanadu.home>
 <1298975837.7828.9.camel@e102144-lin.cambridge.arm.com>
 <4D6D652A.5050502@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Saravana Kannan wrote:

> On 03/01/2011 02:37 AM, Will Deacon wrote:
> > Perhaps a more robust fix would be to remove the register int
> > declarations and handle the parameter marshalling in the same asm block
> > that contains the smc?
> 
> I was thinking the same, but the opposing idea I heard was that not doing it
> inside the asm block would allow GCC to be make better use of the registers.

Indeed.  And a significant body of code out there does rely on this gcc 
feature, so it has to minimally work.

> Didn't have a strong opinion either way, so we went with the implementation
> that was sent out.

ACK.


Nicolas
