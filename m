Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1EKQc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:32:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1EKQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:32:23 -0400
Message-ID: <4DCA9CE2.1080307@zytor.com>
Date: Wed, 11 May 2011 07:27:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Greg KH <greg@kroah.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>	<20110510161137.GA14522@kroah.com> <BANLkTimV8=o1zOeVJs9EA64kc+1=RZCJeA@mail.gmail.com>
In-Reply-To: <BANLkTimV8=o1zOeVJs9EA64kc+1=RZCJeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 06:09 AM, Américo Wang wrote:
> On Wed, May 11, 2011 at 12:11 AM, Greg KH<greg@kroah.com>  wrote:
>> On Tue, May 10, 2011 at 11:00:44AM -0400, Seiji Aguchi wrote:
>>> Description of boot paremeters is following.
>>>
>>>   - efi_pstore_enable
>>>     enable EFI support of pstore.
>>>
>>>   - efi_pstore_len
>>>     Sets the buffer size of EFI variable space used by pstore.
>>
>> Please don't add new boot parameters if at all possible.  Distros will
>> not know to enable them, and users don't know how to either.
>>
>> Use sane defaults, and provide ways to override them if needed, but
>> don't rely on them for new functionality if at all possible.
>
> I agree. It seems that we should enable this by default when APEI and
> EFI are both enabled, this could be done by Kconfig.
>

No, it can't.  That would be a compile-time option, but the selection 
needs to be at runtime.

However, it is still unclear that this is actually a win at all...

	-hpa
