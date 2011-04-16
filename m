Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1DPNK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:10:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58097 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1DPNIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U6x/DriiLiHPQbXCLK38tbxjBlebewpaCfjorV9m2QDWDLlg3uOOEy6rdq7ZMj//6P
         5EvDtVHvCq8ZoXvzphxMSUXZsLhgiFWKt8WDQc69Re5ZB0ZLfErJEiPr/OiZVYx4D777
         L+mVXMWDZbClHV9+fvqhctxplw8ZJBh02xx2A=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <BANLkTi=_vsX6Zx8b82FYWUy5WGxLdMBbMQ@mail.gmail.com>
References: <1301726499-6010-1-git-send-email-namei.unix@gmail.com>
	<BANLkTi=_vsX6Zx8b82FYWUy5WGxLdMBbMQ@mail.gmail.com>
Date: Sat, 16 Apr 2011 21:02:33 +0800
X-Google-Sender-Auth: bclKdaKcX5ES5BaIgiJAmCw79bo
Message-ID: <BANLkTimkSx+ECO_-Tyzgr8LVY3F52TTJXA@mail.gmail.com>
Subject: Re: [PATCH] drivers, mfd: Remove unused variable 'val'
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/11, Liu Yuan <namei.unix@gmail.com> wrote:
> Hi, Samuel, is there another similar fix already pending? I notice the
> latest[ Linus tree[0ebc115da3ed6740, Fri Apr 15 20:31:15 2011 -0700]
> still has this redundant variable.
>
> Thanks,
> Yuan
>
> On Sat, Apr 2, 2011 at 2:41 PM, Liu Yuan <namei.unix@gmail.com> wrote:
>> From: Liu Yuan <tailai.ly@taobao.com>
>>
>>
>> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
>> ---
>>  drivers/mfd/wl1273-core.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
>> index 04914f2..37af778 100644
>> --- a/drivers/mfd/wl1273-core.c
>> +++ b/drivers/mfd/wl1273-core.c
>> @@ -153,7 +153,6 @@ out:
>>  */
>>  static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int
>> volume)
>>  {
>> -       u16 val;
>>        int r;
>>
>>        if (volume > WL1273_MAX_VOLUME)
Hi Liu Yuan:

It has already fixed in the Samuel's for-next branch.
Cheers .

http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=blobdiff;f=drivers/mfd/wl1273-core.c;h=d97a86945174519a6d333bf0527875b63537384d;hp=63d250d9a366aeac9b94ee99bba6b6040f1916f8;hb=f880ff3edc1a6f8cfa98b337dc121824c170164c;hpb=b2b1fc7407b7b989a7582b31e732f81cbc7e1d50
>> --
>> 1.7.1
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
