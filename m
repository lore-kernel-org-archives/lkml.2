Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0LWIXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:23:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55454 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0LWIXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cOR9cWLO0n+V3ic0v6G5vpJAoxldHBkqgdE3u9bIL7wfbnJ/WGVHmqEiLa9FsDC0k6
         +CdxACYrUgBtEmU3DUvhmcL9bA3RkUrsit894NqsvX1aUzQSnSRy2W3ZSAX+znEHHy6p
         JUEJDP9z7yCWleqJVokMYn4bZHQsGph8Y75pA=
MIME-Version: 1.0
In-Reply-To: <20101222132730.GC26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
	<1292998991-26968-4-git-send-email-myungjoo.ham@samsung.com>
	<20101222132730.GC26306@opensource.wolfsonmicro.com>
Date: Thu, 23 Dec 2010 17:23:01 +0900
X-Google-Sender-Auth: UBlDQWGOeCl8tHuFQaL_ZPE5Me0
Message-ID: <AANLkTinj1s2vGJfqg8ypW1WbezpDjZZ1jS3g_LbDdq0O@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] MFD MAX8998/LP3974 Bugfix: incorrect variable name (typo)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:27 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 22, 2010 at 03:23:08PM +0900, MyungJoo Ham wrote:
>> trivial error. (buck1_idx->buck2_idx in the context of buck2 control)
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> This looks like it has no dependency on the rest of the series.

Ok, in the next patch release, the two bugfixes will be separated as
another patch set.

>
>>  drivers/regulator/max8998.c |    4 ++--
>
> Subject line would normally say 'regulator: ' as this is a patch to the
> regulator driver not the MFD.
>


-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
