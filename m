Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0KATaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:30:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42305 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0KATaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H1cvUcAd0SxXS9nOoGmfHYjOW58De0fvuCIVFdDPyUK3hZyKTFAsQqrROf05H4QkSv
         pGCHMyVuDIo6nydrpLTwTIpX+pbgk9vJqFnm2pY4Yyucc5zeF+gtC6q35UoXUEtBCWpy
         rah7oZc8VAd6/cVkULRfIc2xU3WVxWJY1FXDY=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011012008351.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-25-git-send-email-tdent48227@gmail.com>
	<alpine.LNX.2.00.1011012008351.12889@swampdragon.chaosbits.net>
Date: Mon, 1 Nov 2010 21:30:14 +0200
X-Google-Sender-Auth: d9zlcpPfxicyWyU9_cGIQAy49nU
Message-ID: <AANLkTikkca+uveP5xaHjW6bdfSAZv-SyE-NCgFh0nrCM@mail.gmail.com>
Subject: Re: [PATCH 24/29] Staging: yaffs2: yaffs_verify: Add files
From: Pekka Enberg <penberg@kernel.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 9:16 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 1 Nov 2010, Tracey Dent wrote:
>
>> Adding files to yaffs2 directory.
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>> ---
>>  drivers/staging/yaffs2/yaffs_verify.c |  631 +++++++++++++++++++++++++++++++++
>>  drivers/staging/yaffs2/yaffs_verify.h |   41 +++
>>  2 files changed, 672 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/staging/yaffs2/yaffs_verify.c
>>  create mode 100644 drivers/staging/yaffs2/yaffs_verify.h
>>
>> diff --git a/drivers/staging/yaffs2/yaffs_verify.c b/drivers/staging/yaffs2/yaffs_verify.c
>> new file mode 100644
>> index 0000000..89e730b
>> --- /dev/null
>> +++ b/drivers/staging/yaffs2/yaffs_verify.c
> ...
>> +#if 0
>
> Why are you trying to merge new code that's under '#if 0' (and not just
> here, but elsewhere as well)?
> Either it shouldn't be here, in which case it should just be omitted from
> the patch, or it needs to be here eventually in which case it should be
> fixed up so the '#if 0' can go away or simply just be added later when it
> has been fixed up.

You can do all sorts of crazy things under drivers/staging. So no, the
code doesn't need to be cleaned up prior to merging. You are, however,
correct on what needs to be done for this piece of code to be promoted
to mainline proper at some point in time.
