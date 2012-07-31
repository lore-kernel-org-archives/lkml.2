Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2GaI6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:58:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62612 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2GaI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <50179CF0.7050200@parallels.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
	<CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
	<50179CF0.7050200@parallels.com>
Date: Tue, 31 Jul 2012 10:57:58 +0200
Message-ID: <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:53 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> On 07/30/2012 02:42 PM, richard -rw- weinberger wrote:
>> On Mon, Jul 23, 2012 at 10:53 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>>> This project is an attempt to implement the checkpoint-restore functionality
>>> for processes and containers without driving too much code into the kernel tree,
>>> but putting there "various oddball helper code" instead.
>>
>> Is CRIU able to checkpoint a process tree where one or more processes
>> are traced using ptrace()?
>
> No it's not (currently).
>
>> crtools seem to use ptrace() to execute parasite system calls.
>> AFAIK this will only work if the target process is currently not
>> ptraced() by another process.
>>
>
> Yup, exactly.

Dammit, I hoped we can get suspend/resume for UserModeLinux for free
with CRIU. 8-)

-- 
Thanks,
//richard
