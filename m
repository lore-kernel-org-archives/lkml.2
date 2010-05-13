Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab0EMHcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:32:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab0EMHcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=uR1eB5PJD2Fzm3zwbqDkLTlJDWQSJX2ENQs5SrDtKcffke6FSw6tu2Nc9PsAFsMdjp
         Vv/LJNVlvtRbtYDCbNTq3uVUYDRG/3gcosyjZSL1H0fX4k3ma4Ff+V+NvHjywMfzqoEK
         Az88H+Z4tnGEv40MlPjoccNaclEJn5IeOaduY=
MIME-Version: 1.0
In-Reply-To: <AANLkTiniV7MElKMWOuxbyaVWe__X0BmUvIeIuOmq9u1J@mail.gmail.com>
References: <AANLkTiniV7MElKMWOuxbyaVWe__X0BmUvIeIuOmq9u1J@mail.gmail.com>
Date: Thu, 13 May 2010 09:32:13 +0200
Message-ID: <AANLkTikbsM8bBLJvv6-f46F02oNZ3wJWKJFJ7VTz-zJ8@mail.gmail.com>
Subject: Re: diskstats - sectors written, what does it mean for mmc-cards?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does really nobody know how large a mmc-sector is, reported by diskstat?

- Clemens

2010/5/12 Clemens Eisserer <linuxhippy@gmail.com>:
> Hi,
>
> I have a small arm based server running enterly from an mmc-card.
> To get some glue how much the mmc-card is written to, I had a look at
> diskstat, which, after 9 days uptime, looks like:
>
>  254    0 mmcblk0 87047 34549 2851200 3081695 483009 484000 7736450
> 30472168 0 5847544 51650
>  254    1 mmcblk0p1 63356 2037674 920699 7365592
>  254    2 mmcblk0p2 58214 813270 46364 370858
>
> So, to mmcblk0 7736450 sectors have been written, and the kernel had
> to wait 5,7h for the writes to complete.
> But how can I find out how large a sector is?
>
> If I assume its 512 bytes, that would mean 3,8gb have been written to
> that card in the last few days, which seems quite a lot.
>
> Thanks, Clemens
>
