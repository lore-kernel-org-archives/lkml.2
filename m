Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0GaTC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:02:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34715 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0GaTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w3PI93RWe8Y9KLY92f6jwA9HObXX48orYjFda5PGy0QQBVZLOlXteaBvydEh2qS/yL
         bs7dSdS7oRr2PU5inaiWGeLXynR+eG6nHYkp6YWIzpChEze8/LD+pDl0TnJRyzV1pUJH
         YYwV0WrFuIOsLpgslV1OA2XE2oqj/Aw2XQc4k=
Message-ID: <4C547367.6070208@gmail.com>
Date: Sat, 31 Jul 2010 12:03:03 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: jack@suse.cz, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]udf:super.c Fix warning: variable 'sbi' set but not used
References: <1278564133-19682-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1278564133-19682-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any ideas on the status of this?

> This fixes this warning when building the kernel:
>    CC      fs/udf/super.o
> fs/udf/super.c: In function 'udf_load_sequence':
> fs/udf/super.c:1582:22: warning: variable 'sbi' set but not used
> Please have a look, when you have time and let me know.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> ---
>   fs/udf/super.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 612d1e2..12bb651 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1579,9 +1579,7 @@ static int udf_load_sequence(struct super_block *sb, struct buffer_head *bh,
>   {
>   	struct anchorVolDescPtr *anchor;
>   	long main_s, main_e, reserve_s, reserve_e;
> -	struct udf_sb_info *sbi;
>
> -	sbi = UDF_SB(sb);
>   	anchor = (struct anchorVolDescPtr *)bh->b_data;
>
>   	/* Locate the main sequence */

