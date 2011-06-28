Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1F1IMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:12:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61414 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab1F1IJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AegAhQX8eqgooQmNhcLk9yca2NEHlYpJ1Pe2ngotqESpinwBuoTp/LGsZ3gf/HeCil
         tj+2zAJO9mNjsavvQPihV6tj3fu2YmL8/4J3NkW6r4TaeBIYjgLepvAjk+M5AqmS201M
         p9g06sVHWnhMq+HyMeQwVjU8Mgk/21fV1l5Ew=
MIME-Version: 1.0
In-Reply-To: <1309246907.23597.34.camel@sauron>
References: <1309154611.23597.18.camel@sauron>
	<1309178086-10604-1-git-send-email-dbaryshkov@gmail.com>
	<1309246907.23597.34.camel@sauron>
Date: Tue, 28 Jun 2011 12:09:50 +0400
Message-ID: <BANLkTi=8G-aw8ZTJUVYdh7_2u442AonaRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/11, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Mon, 2011-06-27 at 16:34 +0400, Dmitry Eremin-Solenikov wrote:
>> ofpart.ko also provides ofoldpart MTD parser. Add respective
>> MODULE_ALIAS("ofoldpart"); declaration.
>>
>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> ---
>>  drivers/mtd/ofpart.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
>> index aa33b8a..77f0640 100644
>> --- a/drivers/mtd/ofpart.c
>> +++ b/drivers/mtd/ofpart.c
>> @@ -176,3 +176,6 @@ module_init(ofpart_parser_init);
>>  MODULE_LICENSE("GPL");
>>  MODULE_DESCRIPTION("Parser for MTD partitioning information in device
>> tree");
>>  MODULE_AUTHOR("Vitaly Wool, David Gibson");
>> +/* Required so that this module will be picked up ofoldpart
>> + * MTD partition information parser */
>> +MODULE_ALIAS("ofoldpart");
>
> Well, the codyng style documents how multi-line comments should look
> like... And this comment is less readable than your previous
> explanation... But I've fixed this myself and pushed to my tree, thanks!

It seems I've got "All work and no play makes Jack a dull boy" sindrom...

-- 
With best wishes
Dmitry
