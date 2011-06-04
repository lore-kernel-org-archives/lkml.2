Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1FDNcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 09:32:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54316 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab1FDNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 09:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CMCtojqaoFrHJYOpDmDqwQMhJTfHlKzaZhjzZvErG9Fh/lvrLLDnwwfloqprTq2bKW
         x9wMf2HY2iNsVwysZ3vu1t6Rb1ClNEGbQ2o1nrAsIqeEWTMtnsqoiCFi4TGbnpayMyD3
         E60oCPOWteGpduLCN67eKlquQuBDWF0YUszBc=
Message-ID: <4DEA33FA.3070603@lwfinger.net>
Date: Sat, 04 Jun 2011 08:32:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Amit Shah <amit.shah@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Regression for 3.0-rc1 - bisected to commit ea6949b66d084a197dd7f243b72e216a71d9f2ca
References: <4DE97E12.1030900@lwfinger.net> <BANLkTincFSm7N7K2uf9npxKFzTfLp_FttQ@mail.gmail.com>
In-Reply-To: <BANLkTincFSm7N7K2uf9npxKFzTfLp_FttQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2011 05:11 AM, Linus Torvalds wrote:
> On Sat, Jun 4, 2011 at 9:36 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> With kernel 3.0-rc1 and an openSUSE 11.4 distro, my HP dv2815nr notebook
>> fails to boot. Bisection leads to the following:
>>
>> finger@larrylap:~/linux-2.6>  git bisect bad
>> ea6949b66d084a197dd7f243b72e216a71d9f2ca is the first bad commit
>> commit ea6949b66d084a197dd7f243b72e216a71d9f2ca
>> Author: Tejun Heo<tj@kernel.org>
>> Date:   Thu Apr 21 20:54:44 2011 +0200
>>
>>     cdrom: always check_disk_change() on open
>
> This sounds like the infinite disk change bug that was mistakenly
> re-introduced in -rc1 by a bad merge.
>
> It should be fixed by commit 0f48f2600911 ("block: fix mismerge of the
> DISK_EVENT_MEDIA_CHANGE removal"), so current -git should hopefully be
> good.
>
> Pls verify,

Linus,

Thanks for the quick reply. The current -git (v3.0-rc1-134-ga652b99) does indeed 
boot.

Larry
