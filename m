Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0DGN3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:29:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab0DGN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mAYjSx2yy7L3aYtgzpRJEaiEBeiYAW5SpVYWsNUKyS1piYe0LIYJg6sT0WHrloXvgj
         DzWFrFhTe2sEbvWyxZxy85758JeALrjsxFq/LcAQ3Mdv6rzxhCF8f9zkEVe7iDGkCx5J
         lK3R/7n9VgD7oxAF+phwpkNLNV9IPnXLyYDlo=
Message-ID: <4BBC88F4.3080406@gmail.com>
Date: Wed, 07 Apr 2010 06:30:28 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: =?UTF-8?B?w4Frb3MgTWFyw7N5?= <akos@maroy.hu>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: system does not power off - how to debug?
References: <4BBC2E3E.40308@maroy.hu> <4BBC30B3.1000209@gmail.com> <4BBC7998.5080106@maroy.hu>
In-Reply-To: <4BBC7998.5080106@maroy.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 05:24 AM, Ákos Maróy wrote:
> Justin,
>
>> Since this issue seems easily reproducible
>> the best way to find the issue is through
>> a bisect(hardest part is finding the last
>> good kernel),
>> http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
>>
>> hope this helps,
>
> hm, but wouldn't this assume that there is a kernel version, which
> actually works?
>
>
> Akos
>
>


nice!!, so there never was a good kernel version.
In this case I guess the right question is, is
what/where is the shutdown mechanism(in the kernel)
responsible for this and if possible is there already
some mechanism in place for this machine with this issue
i.g. I had to add my machines dmi info to reboot.c
in order for it to reboot properly.

Now keep in mind this could have nothing todo with
adding some dmi entry, this could somewhere else
(which the bisect could reveal(hopefully)).

as for debugging I normally use ohci1394_dma=early
you might be able to catch some strace towards the end
with this.


Justin P. Mattock
