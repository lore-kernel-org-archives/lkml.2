Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1CHFP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:15:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59524 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1CHFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J4xbONtmUN76THOlvedrobZLIRoaE5Il8/SqcZgQm7NFOZL67E3o/2TafQG0gJdZ8G
         mJcIFuuIg4IolozlRkASQnWFd0kPOz5byw8DqEjpDiJtAfS4TQDQJQDggTC0BgZsses9
         QFngo+pzTCoSTz4Gub6O2RwR97rH8Im6RqdC4=
MIME-Version: 1.0
In-Reply-To: <20110307150526.9afedd47.akpm@linux-foundation.org>
References: <20110304154631.GB14672@darkstar>
	<20110307150526.9afedd47.akpm@linux-foundation.org>
Date: Tue, 8 Mar 2011 13:15:54 +0800
Message-ID: <AANLkTimharU+iWRc9Mf_Sk6qnDyoAvuxxnL=3suvwT1j@mail.gmail.com>
Subject: Re: [PATCH 02/04 v2] sysctl: change to use proc_dointvec_bool while needed
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p285G3f2016933

On Tue, Mar 8, 2011 at 7:05 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 4 Mar 2011 23:46:31 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> @@ -374,9 +372,7 @@ static struct ctl_table kern_table[] = {
>> Â  Â  Â  Â  Â  Â  Â  .data Â  Â  Â  Â  Â  = &sysctl_sched_autogroup_enabled,
>> Â  Â  Â  Â  Â  Â  Â  .maxlen Â  Â  Â  Â  = sizeof(unsigned int),
>> Â  Â  Â  Â  Â  Â  Â  .mode Â  Â  Â  Â  Â  = 0644,
>> - Â  Â  Â  Â  Â  Â  .proc_handler Â  = proc_dointvec,
>> - Â  Â  Â  Â  Â  Â  .extra1 Â  Â  Â  Â  = &zero,
>> - Â  Â  Â  Â  Â  Â  .extra2 Â  Â  Â  Â  = &one,
>> + Â  Â  Â  Â  Â  Â  .proc_handler Â  = proc_dointvec_bool,
>> Â  Â  Â  },
>
> This field has changed in linux-next, so I dropped this hunk.
>

Thank you for updating the patch.

-- 
Regards
dave
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
