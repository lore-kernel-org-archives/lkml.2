Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2GaJHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:07:45 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29165 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2GaJHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:07:44 -0400
Message-ID: <5017A053.9000206@parallels.com>
Date: Tue, 31 Jul 2012 13:07:31 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
References: <500D09C9.7060903@parallels.com> <500D1116.7070301@parallels.com> <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com> <50179CF0.7050200@parallels.com> <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
In-Reply-To: <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 12:57 PM, richard -rw- weinberger wrote:
> On Tue, Jul 31, 2012 at 10:53 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> On 07/30/2012 02:42 PM, richard -rw- weinberger wrote:
>>> On Mon, Jul 23, 2012 at 10:53 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>>> This project is an attempt to implement the checkpoint-restore functionality
>>>> for processes and containers without driving too much code into the kernel tree,
>>>> but putting there "various oddball helper code" instead.
>>>
>>> Is CRIU able to checkpoint a process tree where one or more processes
>>> are traced using ptrace()?
>>
>> No it's not (currently).
>>
>>> crtools seem to use ptrace() to execute parasite system calls.
>>> AFAIK this will only work if the target process is currently not
>>> ptraced() by another process.
>>>
>>
>> Yup, exactly.
> 
> Dammit, I hoped we can get suspend/resume for UserModeLinux for free
> with CRIU. 8-)

Sorry :( However, if you can help with patches on that issue that would be
highly appreciated :)

Thanks,
Pavel


