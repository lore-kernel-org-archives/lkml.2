Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1BIXCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:02:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1BIXCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vlXcI+bXfA87tyePq9bSnKr+liICcfdqFWEvtY+QJp1734v2+cUjHSmB7R71w0UMy+
         pszfqnfKK21g4ssjOgx8c+3njWt4Gtv3MC7CU5vV3WWo/O56+vjCpQRwvqpichZf+QAt
         A6zkx+q9th+WRn2EyAzKDarvKRos4/JI8z38A=
MIME-Version: 1.0
In-Reply-To: <4D5315FB.8020004@zytor.com>
References: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
	<4D5315FB.8020004@zytor.com>
Date: Wed, 9 Feb 2011 18:02:09 -0500
Message-ID: <AANLkTimN2oM6E9E34fMffgtH81ZfYcGj6J5nnjGrxGfA@mail.gmail.com>
Subject: Re: Can anyone explain "movl %eax %eax"?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I see. Thank you. So similarly, the operation "xorl %eax,%eax" is
used for the same reason, right? I see that appears in more files.

Regards
Jidong

On Wed, Feb 9, 2011 at 5:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/09/2011 02:24 PM, Jidong Xiao wrote:
>> Hi,
>>
>> In the kernel source, I see in a couple of places, there is "movl %eax
>> %eax". Is this used for alignment purpose?
>>
>> For example, in the following piece of code we can see "movl %eax,%eax".
>>
>
> In x86-64, a dword (long) operation clears the upper 32 bits of the
> target register, so "movl %eax,%eax" clears the upper 32 bits of %rax.
>
>        -hpa
>
>
