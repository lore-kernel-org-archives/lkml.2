Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2JFBDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 21:03:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2JFBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 21:03:40 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <87d30wmnrc.fsf@xmission.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <20121003165105.GA30214@jshin-Toonie> <CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com> <20121004164630.GB2244@phenom.dumpdata.com> <CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com> <871uhcsk93.fsf@xmission.com> <CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com> <87ehlcr4et.fsf@xmission.com> <CAE9FiQU_PSv6afXLcQ8ohrn1wqoVttO+u5MA5xBEE4jJRVx9Mw@mail.gmail.com> <877gr4r40b.fsf@xmission.com> <506F78C9.1000803@zytor.com> <87d30wmnrc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 05 Oct 2012 18:02:19 -0700
To: ebiederm@xmission.com
CC: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <047b1c66-b3a0-4a25-b691-8ead19b7446e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That disappeared 10 years ago...

ebiederm@xmission.com wrote:

>"H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 10/05/2012 02:41 PM, Eric W. Biederman wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>>> with bzImage or vmlinux?
>>>
>>> bzImage I presume.  Certainly the bzImage has lost it's 896M limit,
>>> which is where ultimiately the 896M limite came from.
>>>
>>
>> ~896M (actually comes from i386, not from bzImage...
>
>Right it was 1G - VMALLLOC_SIZE.
>
>At some point that affected the boot protocol as the maximum address we
>could load ramdisks.
>
>Eric

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
