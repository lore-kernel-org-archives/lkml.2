Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1LNVlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:41:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45827 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1LNVlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:41:24 -0500
MIME-Version: 1.0
In-Reply-To: <4EE8E52C.1030506@gmail.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-2-git-send-email-b29396@freescale.com> <4EE8E52C.1030506@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:41:01 -0700
X-Google-Sender-Auth: 9YXJ7B-SzuaKD1hcv-qWElIb5rA
Message-ID: <CACxGe6tQO=5oGXjpZ_VD+Pzs+mPKgdciKBHiA6YBf4PHfe_Q7g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] dt: add of_get_child_number helper function
To: Rob Herring <robherring2@gmail.com>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:04 AM, Rob Herring <robherring2@gmail.com> wrote:
> Dong,
>
> On 12/14/2011 10:03 AM, Dong Aisheng wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> Currently most code to get child number in kernel are almost same,
>> add a helper to implement this function for dt to use.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  include/linux/of.h |   17 +++++++++++++++++
>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index 4948552..09d53dc 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -189,6 +189,18 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>>       for (child = of_get_next_child(parent, NULL); child != NULL; \
>>            child = of_get_next_child(parent, child))
>>
>> +static inline int of_get_child_number(struct device_node *np)
>
> I would call this of_get_child_count instead.

I agree.

>
> Rob



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
