Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2KCVht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 17:37:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2KCVhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 17:37:48 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQW+B8_vBT4A10ab4iOAQD9b-Ef84dsSX7p3nVQSN2w0=Q@mail.gmail.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com> <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com> <20121030134442.GB27463@phenom.dumpdata.com> <CAE9FiQVXzOQG2XmA5Y_DX1JCGg_-LdM9tG3Chq7-7rNvUseRhg@mail.gmail.com> <CAE9FiQW+B8_vBT4A10ab4iOAQD9b-Ef84dsSX7p3nVQSN2w0=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make xen happy
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 03 Nov 2012 17:37:14 -0400
To: Yinghai Lu <yinghai@kernel.org>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <a58d5329-a1db-418b-9caa-06b7a79051ec@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am travelling at the moment... I hope to be able to look at it Sunday.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Tue, Oct 30, 2012 at 7:47 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Oct 30, 2012 at 6:44 AM, Konrad Rzeszutek Wilk
>> <konrad@kernel.org> wrote:
>>> On Wed, Oct 10, 2012 at 11:13:45PM -0700, Yinghai Lu wrote:
>>> So which branch should I try out? Do you have one with all of the
>>> required patches so I can just do a 3.7-rc3 'git pull' and try it
>out?
>>
>> add for-x86-mm-test branch, and it is based on 3.7-rc3, and merged
>> with for-x86-mm branch.
>>
>> so you can try
>>        
>git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-x86-mm-test
>>
>> there is conflicts between for-x86-mm and 3.7-rc3, and attached patch
>> could be used to fix them
>>
>
>Peter/Ingo,
>
>can you put for-x86-mm-test to tip for more testing?
>
>or you want to rebase the whole patchset?
>
>Thanks
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
