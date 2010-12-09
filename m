Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0LIGtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:49:02 -0500
Received: from mail-qy0-f177.google.com ([209.85.216.177]:64872 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab0LIGtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KT2gpSsLszhK2waqmBSFhjYyGfbLFYo51tdwZgqUHeBlm6jd+o7ayTR5fUBnd5sIEb
         N0mM98R2dsPlecq1xbeHlOZh0C4fa9Wp6ywIR0OouR8uAk/c458obFtEhgMmrgls/I1O
         r5WGmI4vKEfGTTm2pLoWOpOL0BGrQFtTdMxEU=
MIME-Version: 1.0
In-Reply-To: <20101209152800.C7A0.A69D9226@jp.fujitsu.com>
References: <1291868401-32237-1-git-send-email-namhyung@gmail.com> <20101209152800.C7A0.A69D9226@jp.fujitsu.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 9 Dec 2010 15:48:39 +0900
Message-ID: <AANLkTimUJ0mOkNe+ATAxDze_zHbWU8R1cJinEfX98Azw@mail.gmail.com>
Subject: Re: [PATCH] poll: fix a typo in comment
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 15:31, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>  include/linux/poll.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/poll.h b/include/linux/poll.h
>> index 56e76af78102..afd3375e58ee 100644
>> --- a/include/linux/poll.h
>> +++ b/include/linux/poll.h
>> @@ -57,7 +57,7 @@ struct poll_table_entry {
>>  };
>>
>>  /*
>> - * Structures and helpers for sys_poll/sys_poll
>> + * Structures and helpers for sys_select/sys_poll
>>   */
>
> Now we don't have sys_poll() and sys_poll() function. At least they
> are hidden by SYSCALL_DEFINEx() macro.
>
> so probably, "for select/poll syscall" is better explanation?
>

Good point. Will resend.
Thanks.


-- 
Regards,
Namhyung Kim
