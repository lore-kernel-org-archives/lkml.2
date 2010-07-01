Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab0GAVao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:30:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33666 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab0GAVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JbadtZim5dr9Ru3o0ZOHfi3yeNqJk0heHkvfe5AbE6a14XHkIPRSArKB8cOSIm8BeX
         X0Kni5ZGP6vUB/8yWpy1qjzHHMYMCSxAsTJtetx377GWhtA0M67Me4FSDQeMYHm15srn
         esO3+gwJitw652WZH1JoPaVvj6ImR+ZxmeqTI=
Message-ID: <4C2D0916.8030002@gmail.com>
Date: Thu, 01 Jul 2010 14:31:02 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers
 for userspace to types.h
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007011707.31783.arnd@arndb.de> <4C2CCE57.40208@gmail.com> <201007012238.58335.arnd@arndb.de>
In-Reply-To: <201007012238.58335.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 01:38 PM, Arnd Bergmann wrote:
> On Thursday 01 July 2010, Justin P. Mattock wrote:
>> o.k. I resent an updated version. keep in mind this is a bit confusing
>> with the __KERNEL__ being in there multiple times, but with the v2 I'm
>> able to see the #warning message with my little program.
>
> Well, it's technically correct, but the #ifndef __KERNEL__ in there
> would better get dropped, since you are already in the #else path.
>

ahh.. I see now(makes sense). I resent this with the above change.

>> As for the patch itself hopefully I corrected it's changelog etc..
>> lately I've been a bit confused with the whole sighned off thing i.g.
>> you suggested the #else so naturally I should add your name with a
>> sighned off, but with other patches I was told not to do so due to the
>> sighned off procedure/process. I'll re-read the submitting patches again
>> to make sure.
>
> You got that part right. The S-o-b only ever gets added by a person
> sending a patch for the sending address, so you would not add my
> address as S-o-B, though you could add it as Cc:.
> When someone picks up your patch and forwards it, that person
> will add his/her own S-o-b line below yours and keep you listed
> as From.
>
> 	Arnd
>

o.k. I added a Cc, then down the line the sob's are added etc.

Justin P. Mattock
