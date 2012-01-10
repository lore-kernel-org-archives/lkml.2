Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2AJMTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:19:04 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:54039 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2AJMTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:19:02 -0500
Message-ID: <4F0C2C4E.3000703@tu-ilmenau.de>
Date: Tue, 10 Jan 2012 13:17:18 +0100
From: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111201 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de> <4F096E26.4090201@redhat.com> <4F0C0EBB.3090506@tu-ilmenau.de> <4F0C1369.9070607@redhat.com>
In-Reply-To: <4F0C1369.9070607@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, me again.

Thank you for your instructions, I will send the patch right after this
mail.

On 01/10/12 11:31, Avi Kivity wrote:
>> I prepare/adapt everything to the mentioned styles/policy.
>> (I'll insert 2 additional ops for getting "cpuid" and "id of vcpu"...)
> What do you mean by "id of vcpu"?
I mean the number of the corresponding vcpu.
(So mostly "vcpu->vcpu_id" ...)
It is necessary for "pr_err_ratelimited"-complains, if cpuid-vendor is
unknown ...
("Jan 10 12:14:55 thinkrat kernel: [ 4476.484359] kvm: 15680: cpu0
unknown vendor - assuming intel")

>>> Please post patches separately, not as attachments to a single email. 
>>> See Documentation/SubmittingPatches.
>> One thing, which is not fully clear to me: Where exactly should I post
>> the patches?
>> Also to/in this mail/group as an empty mail (containing the patch as
>> text-body) per patch?
>> Or all (3 patches) at once?
> One patch per email, with a cover letter.  Git can help you format and
> send them:
>
>   # format three patches, with a cover letter:
>   $ git format-patch -3 --cover-letter -n -o patches
>   # edit the cover letter:
>   $ vi patches/0000-cover-letter-patch
>   # post them:
>   $ git send-email --to kvm@vger.kernel.org patches/*.patch
>
Thx, I'll do it this way...


regards Stephan
