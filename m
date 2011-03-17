Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1CQRH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:07:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44295 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1CQRH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:07:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyril Hrubis <metan@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
References: <20110317064523.GA1995@ucw.cz>
	<AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
	<20110317125839.GB21290@atrey.karlin.mff.cuni.cz>
Date: Thu, 17 Mar 2011 10:07:12 -0700
In-Reply-To: <20110317125839.GB21290@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Thu, 17 Mar 2011 13:58:39 +0100")
Message-ID: <m1d3lpbrr3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+/8R4jBE2ssk3npE6WyT1hIqc2sEsTchg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cyril Hrubis <metan@ucw.cz>
X-Spam-Relay-Country: 
Subject: Re: reboot/kexec in 2.6.38
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Hrubis <metan@ucw.cz> writes:

> Hi!
>> > I got report that  reboot/kexec does not work in recent kernels.
>> >
>> > I tried both kexec and reboot in 2.6.38, and it worked ok. Maybe
>> > config issue?
>> 
>> I think it's config issue. Never heard of this.
>>
>
> I've seen that on my zaurus a month or two ago. When kexeced to pxa-linux-2.6
> then tried to kexec again. The last thing I've seen was Bye on the framebuffer
> console and the machine freezed.

The basic kexec code has been stable and solid for a long time so kexec
failures are almost always hardware interaction problems.

Someone not stopping dma, or someone not putting the hardware in a state
that the next kernel can figure out how to initialize it.

Eric
