Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0KATZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:25:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55167 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0KATZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LofDQg4ovBI1CQ2c6IC2VZRBqnlzCTtuDooRjtiFLeV4Yy+hUNweXJoMK1T3UH4Mhu
         hP3kv30uw3qVRpSdVVPBgOhr3MXcOB4BwgEYK0hMYpEsvrbbDswGF/w0mJpLBK0bu7ul
         E9Hs7FfxKv4slhdQd09Oq8ZQP6hQRAmDDtgoU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimx9KhUZhHKx_FJ=orUoRaVHaye3G9Uazg4iZmm@mail.gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-5-git-send-email-tdent48227@gmail.com>
	<AANLkTimx9KhUZhHKx_FJ=orUoRaVHaye3G9Uazg4iZmm@mail.gmail.com>
Date: Mon, 1 Nov 2010 15:25:32 -0400
Message-ID: <AANLkTik1tCS++ina=zFhyTPbXOjwMko7jW=zodt1zypz@mail.gmail.com>
Subject: Re: [PATCH 04/29] Staging: yaffs2: moduleconfig.h: Add file
From: Tracey Dent <tdent48227@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/10, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
>> Adding files to yaffs2 directory.
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>> ---
>>  drivers/staging/yaffs2/moduleconfig.h |   86
>> +++++++++++++++++++++++++++++++++
>>  1 files changed, 86 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/staging/yaffs2/moduleconfig.h
>>
>> diff --git a/drivers/staging/yaffs2/moduleconfig.h
>> b/drivers/staging/yaffs2/moduleconfig.h
>> new file mode 100644
>> index 0000000..4b4d642
>> --- /dev/null
>> +++ b/drivers/staging/yaffs2/moduleconfig.h
>> @@ -0,0 +1,86 @@
>> +/*
>> + * YAFFS: Yet another Flash File System . A NAND-flash specific file
>> system.
>> + *
>> + * Copyright (C) 2002-2010 Aleph One Ltd.
>> + *   for Toby Churchill Ltd and Brightstar Engineering
>> + *
>> + * Created by Martin Fouts <Martin.Fouts@palmsource.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU Lesser General Public License version
>> 2.1 as
>> + * published by the Free Software Foundation.
>> + *
>> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
>> + */
>> +
>> +#ifndef __YAFFS_CONFIG_H__
>> +#define __YAFFS_CONFIG_H__
>> +
>> +#ifdef YAFFS_OUT_OF_TREE
>
> You probably want to drop this header as well...
>
 Yes, I was going to make up a clean up patch set when or if this gets merge.
