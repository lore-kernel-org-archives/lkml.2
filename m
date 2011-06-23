Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab1FWNyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:54:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64568 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1FWNyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K67PM2lRuGMWE39X4fJSGcn9IB9MTCw6IcEX3qejJzsgUSBL1L9CvhzcusLO0izplN
         jeKFHBlMstU2d0UPJ0Buf+PnTtIpmq+VXjTZRuI9I6s49d4xUDNZdEybzqLCBPqMriAF
         pRUNEPUgzQItEerc9PIwx/bZXu4B/uMwK4QYU=
MIME-Version: 1.0
In-Reply-To: <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
	<20110623153116.404f2a63.taeuber@bbaw.de>
	<BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
Date: Thu, 23 Jun 2011 15:54:52 +0200
Message-ID: <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
Subject: Re: extra slash in current path
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: yuyichao-mit <yuyichao@mit.edu>
Cc: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 3:32 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
> On Thu, Jun 23, 2011 at 9:31 AM, Lars Täuber <taeuber@bbaw.de> wrote:
>> Hi,
>>
>> Am Thu, 23 Jun 2011 09:14:18 -0400
>> yuyichao-mit <yuyichao@mit.edu> schrieb:
>>> The problem is like this:
>>>
>>> $ cd /
>>> $ pwd
>>> /
>>>
>>> $ cd /
>>> $ pwd
>>> //
>>
>> didn't you mean?:
>> $ cd //
>> $ pwd
>> //
>
> yes, exactly.
>
> Sorry for the typo (copy-paste~~~)
>

Is this really a kernel issue?
rw@raccoon:~> cd //
rw@raccoon://> pwd
//
rw@raccoon://> ls -l /proc/self/cwd
lrwxrwxrwx 1 rw users 0 23. Jun 15:53 /proc/self/cwd -> /

-- 
Thanks,
//richard
