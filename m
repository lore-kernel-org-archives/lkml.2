Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1CJEdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:33:46 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55851 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1CJEdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sse6/zT7Mbm/aFPUY/2HWLuXfwp+1/6UPkXRsq84eeQZnzxoExRUGVpV1d0NsArXWV
         uhXnsVnpEiahV/AGKhjkGR+y0nWb+nN3RyltFNstrpFX+3Z8THEAx2gu0w4xyfnmgax/
         SQMsj3BANIpoEUfaG2m3/be/x0RsV8OROxeJ4=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103082313130.19969@pobox.suse.cz>
References: <1299459180-11321-1-git-send-email-leemgs1@gmail.com>
	<1299459180-11321-2-git-send-email-leemgs1@gmail.com>
	<AANLkTi=FYHX3Z1zAi5BqHqxRSQK-iOJ+tSvZwj4csZ=2@mail.gmail.com>
	<alpine.LNX.2.00.1103082313130.19969@pobox.suse.cz>
Date: Thu, 10 Mar 2011 13:33:44 +0900
Message-ID: <AANLkTikmftpc-TCw-JLQv5AJKDJ3e=j3uXqUtucrX4Rn@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] cgroup:doc Update cpuset info & webiste via cgroup.
From: Geunsik Lim <leemgs1@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Paul Menage <menage@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 7:13 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 8 Mar 2011, Paul Menage wrote:
>
>> > cpuset website is changed.
>> > and, update list of cpuset using cgroup(controller group).
>> >
>> > Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> Acked-by: Paul Menage <menage@google.com>
>>
>> You should forward these to Andew Morton for the -mm tree.
>
> I can take it since you have Acked it.
>
> Applied, thanks.
Thanks Jiri.
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
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
