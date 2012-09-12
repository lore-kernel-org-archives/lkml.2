Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2ILMpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:45:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33752 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2ILMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120912080642.GA19396@mwanda>
References: <1347386432-12954-1-git-send-email-peter.senna@gmail.com>
	<20120912080642.GA19396@mwanda>
Date: Wed, 12 Sep 2012 14:45:50 +0200
Message-ID: <CA+MoWDptdWtAoMvrQ==YN-VA0z9DQPhh_gLkUwJKof-FNHA+zw@mail.gmail.com>
Subject: Re: [PATCH] drivers/media: Removes useless kfree()
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll split this patch in one patch for file and resend.

On Wed, Sep 12, 2012 at 10:06 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Tue, Sep 11, 2012 at 08:00:32PM +0200, Peter Senna Tschudin wrote:
>> diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
>> index cc11260..748da5d 100644
>> --- a/drivers/media/dvb-frontends/lg2160.c
>> +++ b/drivers/media/dvb-frontends/lg2160.c
>> @@ -1451,7 +1451,6 @@ struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
>>       return &state->frontend;
>>  fail:
>>       lg_warn("unable to detect LG216x hardware\n");
>> -     kfree(state);
>>       return NULL;
>>  }
>
> I wish you had fixed this the same as the others and removed the
> goto.  Also the printk is redundant and wrong.  Remove it too.
>
> regards,
> dan carpenter
>



-- 
Peter
