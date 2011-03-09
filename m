Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1CIOmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:42:11 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46442 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab1CIOmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MHwsKKFDbK4MJOI0vQJpgCCrjbsnzlldDD3hW3OTHx7LmLuhpSeI4BrdGPK5HpAEeD
         m9s0xN88U/7zHU+1yQ41TEUKfsATU9Pf66SShCR+eoXKhClKE/ZoITSr2Y8VwCSQMSXj
         OUzxoYl8hc6e6zLugoi5RGIPravP2Q5zrbqzE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimBTs43Bi+-aKuMkgpA1vQbSEMKkSdBQ6CcfzF7@mail.gmail.com>
References: <1299459180-11321-1-git-send-email-leemgs1@gmail.com>
	<1299459180-11321-3-git-send-email-leemgs1@gmail.com>
	<AANLkTimBTs43Bi+-aKuMkgpA1vQbSEMKkSdBQ6CcfzF7@mail.gmail.com>
Date: Wed, 9 Mar 2011 23:42:06 +0900
Message-ID: <AANLkTikGJaydyu0AUg5WAJuVx4ULTpghhj1h+biQP7vy@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] cgroup:doc Update suitable words to explain cgroups.
From: Geunsik Lim <leemgs1@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 6:51 AM, Paul Menage <menage@google.com> wrote:
> On Sun, Mar 6, 2011 at 4:53 PM, Geunsik Lim <leemgs1@gmail.com> wrote:
>> Update a sutible words to explaind / understand cgroups cotents.
>
> s/sutible/suitable/
> s/explaind/explain/
> s/cotents/contents/
Thank you for your correction about my spelling.
I will resend this patch.
>
> Paul
>>
>> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  Documentation/cgroups/cgroups.txt |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
>> index 44b8b7a..7252cbd 100644
>> --- a/Documentation/cgroups/cgroups.txt
>> +++ b/Documentation/cgroups/cgroups.txt
>> @@ -110,22 +110,22 @@ university server with various users - students, professors, system
>>  tasks etc. The resource planning for this server could be along the
>>  following lines:
>>
>> -       CPU :           Top cpuset
>> +       CPU :          "Top cpuset"
>>                        /       \
>>                CPUSet1         CPUSet2
>> -                  |              |
>> -               (Profs)         (Students)
>> +                  |               |
>> +               (Professors)    (Students)
>>
>>                In addition (system tasks) are attached to topcpuset (so
>>                that they can run anywhere) with a limit of 20%
>>
>> -       Memory : Professors (50%), students (30%), system (20%)
>> +       Memory : Professors (50%), Students (30%), system (20%)
>>
>> -       Disk : Prof (50%), students (30%), system (20%)
>> +       Disk : Professors (50%), Students (30%), system (20%)
>>
>>        Network : WWW browsing (20%), Network File System (60%), others (20%)
>>                                / \
>> -                       Prof (15%) students (5%)
>> +               Professors (15%)  students (5%)
>>
>>  Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
>>  into NFS network class.
>> --
>> 1.6.2.5
>>
>>
>



-- 
Regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
