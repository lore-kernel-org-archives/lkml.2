Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2BCWwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:52:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49949 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2BCWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:52:12 -0500
Message-ID: <4F2C6517.3040203@codemonkey.ws>
Date: Fri, 03 Feb 2012 16:52:07 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
In-Reply-To: <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 12:07 PM, Eric Northup wrote:
> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com>  wrote:
> [...]
>>
>> Moving to syscalls avoids these problems, but introduces new ones:
>>
>> - adding new syscalls is generally frowned upon, and kvm will need several
>> - syscalls into modules are harder and rarer than into core kernel code
>> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>> mm_struct
> - Lost a good place to put access control (permissions on /dev/kvm)
> for which user-mode processes can use KVM.
>
> How would the ability to use sys_kvm_* be regulated?

Why should it be regulated?

It's not a finite or privileged resource.

Regards,

Anthony Liguori

>

