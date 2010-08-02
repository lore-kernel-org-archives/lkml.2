Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0HBBBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:01:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52535 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0HBBBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TpjPZBNdD5nUUQReqm0c8z1EHzIt3FTUDQAOLNVmkptufhzGFdUF5BzYpfL6FYAUX7
         +aYxaQFytXROkfB8IjlzIio6QSUmvFoaGfjqbccgJJxHKjZvGxNdrhY+0ebYZ6Dv2JpT
         RCSsdwPXkl67GdMV4wZFNMzpZx0dqIyiww+FM=
Message-ID: <4C5618DA.1020407@gmail.com>
Date: Sun, 01 Aug 2010 18:01:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Pauli Nieminen <suokkos@gmail.com>
Subject: Re: [Bug #16337] general protection fault: 0000 [#1] SMP
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera> <Aan7wZ97YaE.A.TCF.1qXVMB@chimera>
In-Reply-To: <Aan7wZ97YaE.A.TCF.1qXVMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2010 06:52 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16337
> Subject		: general protection fault: 0000 [#1] SMP
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2010-07-03 22:59 (30 days old)
> Message-ID	:<4C2FC0E3.6050101@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127819798215589&w=2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Ive played around with the machine that originally hit this. but still 
cant seem to reproduce or trigger this.

Justin P. Mattock
