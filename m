Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1E0Pa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:30:28 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58344 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab1E0Pa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:30:26 -0400
Message-ID: <4DDFC388.1050506@ti.com>
Date: Fri, 27 May 2011 21:00:16 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Marc Zyngier <Marc.Zyngier@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
References: <1306343335.21578.65.camel@twins>	 <1306358128.21578.107.camel@twins>	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>	 <1306405979.1200.63.camel@twins>	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>	 <20110526154508.GA13788@redhat.com> <1306425584.2497.81.camel@laptop>	 <1306426148.2497.83.camel@laptop> <20110526170422.GA18413@redhat.com>	 <1306430264.2497.88.camel@laptop> <1306430633.2497.91.camel@laptop>	 <4DDFC1D6.4010303@ti.com> <1306510165.27474.272.camel@e102391-lin.cambridge.arm.com>
In-Reply-To: <1306510165.27474.272.camel@e102391-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2011 8:59 PM, Marc Zyngier wrote:
> On Fri, 2011-05-27 at 20:53 +0530, Santosh Shilimkar wrote:
[..]

>> Are you planning send version of this patch for stable .39
>> too ?
>
> .39 is fine, as the ttwu() changes only appeared in mainline during the
> current merge window.
>
Thanks Marc for info.

Regards
Santosh

