Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1KHORI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:17:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64254 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab1KHORF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111081027310.1964@pobox.suse.cz>
References: <1320455660-20989-1-git-send-email-levinsasha928@gmail.com> <alpine.LNX.2.00.1111081027310.1964@pobox.suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 Nov 2011 16:16:42 +0200
Message-ID: <CA+1xoqfC0UmuBnQ8p+xfszVZ26fBg6nv6ZZGWx+ZhbYF3fDnsg@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL] MAINTAINERS: Update KVM doc path
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 11:27 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 5 Nov 2011, Sasha Levin wrote:
>
>> Cc: Jiri Kosina <trivial@kernel.org>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 506fe49..0acdc78 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3732,7 +3732,7 @@ M:      Marcelo Tosatti <mtosatti@redhat.com>
>>  L:   kvm@vger.kernel.org
>>  W:   http://kvm.qumranet.com
>>  S:   Supported
>> -F:   Documentation/*/kvm.txt
>> +F:   Documentation/*/kvm/
>
> By that you are dropping Documentation/ia64/kvm.txt and
> Documentation/s390/kvm.txt from the pattern which I guess is not what you
> want?

Yup, I meant to add it, not replace what was there before :)

Will resend.

>>  F:   arch/*/kvm/
>>  F:   arch/*/include/asm/kvm*
>>  F:   include/linux/kvm*
>> --
>> 1.7.7.2
>>
>
> --
> Jiri Kosina
> SUSE Labs
>
