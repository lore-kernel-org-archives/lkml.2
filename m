Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab0KPKeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:34:02 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54341 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab0KPKeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i9qsSSx+9C1rregmqYr75rW+KMuQMBRs1+/3uiufwGQo1O9+zq5gUUGDifdKS81uos
         AsQTbrlc6x/4N9KX1CVGqkBYDpQASJDZ7Tg7oMsXmINZGs4wUh6u8RMzASvQE6sOK1ib
         Z36udZqdEf+KNYqN/NPr56zA0a7creH73v3ZM=
MIME-Version: 1.0
In-Reply-To: <334828.67526.qm@web113308.mail.gq1.yahoo.com>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1011151602090.29081@chino.kir.corp.google.com>
	<334828.67526.qm@web113308.mail.gq1.yahoo.com>
Date: Tue, 16 Nov 2010 11:33:59 +0100
Message-ID: <AANLkTimQWXLvCQU-Ztq=6Ljv0Er6CgTROF+oiYGqzjJ7@mail.gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:04 AM, Martin Knoblauch
<spamtrap@knobisoft.de> wrote:
> CC trimmed for sanity ...
>
> ----- Original Message ----
>
>> From: David Rientjes <rientjes@google.com>
>> To: Jesper Juhl <jj@chaosbits.net>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>; Andrew Morton
>><akpm@linux-foundation.org>; Linus Torvalds <torvalds@linux-foundation.org>;
>>LKML <linux-kernel@vger.kernel.org>; Ying Han <yinghan@google.com>; Bodo Eggert
>><7eggert@web.de>; Mandeep@yahoo.com
>> Sent: Tue, November 16, 2010 1:06:21 AM
>> Subject: Re: [PATCH] Revert oom rewrite series
>>
>>
>> Thanks for the report!  I'll get  involved with kde-devel and send a patch
>> to remove this dependency on newer  kernels to expedite the process.
>>
>>  [ Others with reports of deprecated use  of oom_adj can contact me
>>    privately and I'll find the parties of  interest to avoid topics
>>    unrelated to the kernel itself on LKML.  ]
> David,
>
>  another one for your collection. You asked for it :-) This is CentOS-5.5
> running on top of kernel 2.6.36, likely out of initrd:
>
> $ dmesg | grep deprecated
> [    2.430330] nash-hotplug (67): /proc/67/oom_adj is deprecated, please use
> /proc/67/oom_score_adj instead.

...and another, on Fedora 14, 2.6.37-rc1-git11:

auditd (2583): /proc/2583/oom_adj is deprecated, please use
/proc/2583/oom_score_adj instead.

Cheers,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
