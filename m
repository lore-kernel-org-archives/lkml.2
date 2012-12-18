Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2LRVII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:08:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33856 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab2LRVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:08:05 -0500
Message-ID: <50D0DB1A.5010407@zytor.com>
Date: Tue, 18 Dec 2012 13:07:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@web.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/27] x86, 64bit: early #PF handler set page table
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <1355814959-10573-7-git-send-email-yinghai@kernel.org> <CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com> <50D0D6D1.70400@zytor.com> <CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
In-Reply-To: <CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 12:55 PM, Yinghai Lu wrote:
> On Tue, Dec 18, 2012 at 12:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/18/2012 12:43 PM, Yinghai Lu wrote:
> 
>>
>> That is putting the cart before the horse.  What is the specific requirement
>> with kgdb here (I didn't see any email on that, please don't have private
>> back conversations)?  Either way, however, kgdb is a tool to debug the
>> kernel... having it a barrier for proper functionality of the kernel is not
>> acceptable.
> 
> did not hear back from Jason or Jan.
> 
> Looks like last mail in LKML from Jason is about Oct 20
> 
> looks like kgdb is want DB, BP, and PF are set at first.
> 
> and just after that early_param for kgdbwait will get into to hold the kernel.
> 
> then command from kgdb could dump ram etc.
> 

So in that case, kgdb is broken and will need to be fixed up.  That
happens all the time with debugging tools.

	-hpa

