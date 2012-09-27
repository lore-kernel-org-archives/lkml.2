Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2I0CaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:30:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38452 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2I0CaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:30:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: minyard@acm.org
Cc: Corey Minyard <cminyard@mvista.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
References: <1348681743-16129-1-git-send-email-minyard@acm.org>
	<87lifwmib4.fsf@xmission.com> <50639F4F.8010404@mvista.com>
	<87wqzgl28h.fsf@xmission.com> <5063A6DD.9070202@acm.org>
Date: Wed, 26 Sep 2012 19:30:01 -0700
In-Reply-To: <5063A6DD.9070202@acm.org> (Corey Minyard's message of "Wed, 26
	Sep 2012 20:07:41 -0500")
Message-ID: <87sja4kxjq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX187KhS2Oh4UL3mx/36+FCPl1aLcSXW6vrs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;minyard@acm.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH] namespace: Add an identifier to the namespace file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard <tcminyard@gmail.com> writes:

> On 09/26/2012 07:48 PM, Eric W. Biederman wrote:
>> For netfilter or any other interface what should happen is that a file
>> descriptor is passed in and the network namespace is derived from the
>> file descriptor.
>>
>> Given that netfilter is per network namespace I'm not certain how
>> filtering per network namespace would make sense.
>>
>> When I have poked my nose into netfilter I have had the hard problem
>> that I have not figured out how to translate the parameters supplied
>> by userspace into a more appropriate in kernel form, so I'm not certain
>> how to implement passing a file descriptor into netfilter efficiently.
>
> Yeah, that's kind of where I am stuck, too. netfilter used to be global,
> so if it's not, this may be a "You can't do that any more".

I expect this will come down closer to you can't do it that way anymore.

Eric
