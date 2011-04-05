Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1DEQKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:10:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1DEQKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qwwuu1yoNgRB/lYRlk9e/fSU8R+rLNDfJh0l8eOMUHKboupQ4J2AC8u3R57iiSZbKj
         DBleF3F32hHgW+neVNE0KB7rQejqYDxonXIFOMK+9FPRaNyG2bog73xTWjMDCX04LlXJ
         5fRnDdzuX1f7HILTqLj6ZDD9rtwKHRwFWuhSI=
MIME-Version: 1.0
In-Reply-To: <4D9B3C10.9060704@suse.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
	<AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
	<201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
Date: Tue, 5 Apr 2011 18:10:22 +0200
Message-ID: <BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 5:58 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 04/05/2011 09:30 AM, Bastien ROUCARIES wrote:
>> Ping ? You said on bugzilla it is related to acl but see nothing
>
> Yeah, I think it's related to the nesting not being quite right, but I
> need to look into it more. I've been unable to reproduce the problem
> locally.

You could reproduce quite easilly using with a lot of git pull in
parallel (in a lot of different repo)... In less than one hours if you
have luck

Bastien
>
> - -Jeff
>
>> On Thu, Mar 31, 2011 at 5:04 PM, Bastien ROUCARIES
>> <roucaries.bastien@gmail.com> wrote:
>>> Le lundi 28 mars 2011 11:14:28, Bastien ROUCARIES a écrit :
>>>> On Tue, Mar 8, 2011 at 4:22 PM, Bastien ROUCARIES
>>>>
>>>> <roucaries.bastien@gmail.com> wrote:
>>>>> On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>>>> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
>>>>>>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>>>>>>> Hi,
>>>>>>>
>>>>>>> I take me more than two days of testing to reporduce this bugs with
>>>>>>> trace enabled. My filesystem was quite slow and this bugs seems to be
>>>>>>> timing related.
>>>>
>>>> Any news of this bug? Could I do something to help ?
>>>>
>>>> bastien
>>>>
>>>>> Ok bastien
>>>
>
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/
>
> iEYEARECAAYFAk2bPBAACgkQLPWxlyuTD7ILtQCcDkPc1aAWmai1nTUHFxrLZzII
> iUQAn2ZLGtLFghO4oGs9R2iDiY2Mtnvz
> =UrzR
> -----END PGP SIGNATURE-----
>
