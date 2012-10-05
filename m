Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2JEVhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:37:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50013 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2JEVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <87ehlcr4et.fsf@xmission.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<20121003165105.GA30214@jshin-Toonie>
	<CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com>
	<20121004164630.GB2244@phenom.dumpdata.com>
	<CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com>
	<871uhcsk93.fsf@xmission.com>
	<CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com>
	<87ehlcr4et.fsf@xmission.com>
Date: Fri, 5 Oct 2012 14:37:42 -0700
X-Google-Sender-Auth: GkVED5WMkiKSSamMrInv8WH--Lk
Message-ID: <CAE9FiQU_PSv6afXLcQ8ohrn1wqoVttO+u5MA5xBEE4jJRVx9Mw@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 2:32 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Fri, Oct 5, 2012 at 2:04 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>> Is there a git commit that explains what the 'big range' problem is?
>>>
>>> At least on x86_64 this was recently tested and anywhere below 4G is
>>> good, and there is a patch floating around somewhere to remove this
>>> issue.
>>
>> patch for kernel or kexec-tools?
>
> kernel.
>
> The sgi guys needed a kdump kernel with 1G of ram to dump their all of
> the memory on one of their crazy large machines and so investigated
> this.
>
> Basically they found that a kdump kernel loaded anywhere < 4G worked,
> the only change that was needed was to relaxy the 896M hard code.
>
> In one test they had a kdump kernel loaded above 2G.

with bzImage or vmlinux?
