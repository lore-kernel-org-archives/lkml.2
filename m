Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab1FWNdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:33:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37152 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1FWNc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=x9mU0TFaaoUTB5jhSX9Wiyr2N8TKQzWdnuo9NowtGLwMn/ACAdzvb607is+rN7Vaew
         uFdcfh4oB+iyUKMzmT/wcpZx1YJQ9RBR4U7p+a0/1mWujmSUK7BA5PCIvvFOv8YExNQX
         LcK4m4cDZmkMm7+Ih2i40F1JByBdYhvn5hNAw=
MIME-Version: 1.0
In-Reply-To: <20110623153116.404f2a63.taeuber@bbaw.de>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com> <20110623153116.404f2a63.taeuber@bbaw.de>
From: yuyichao-mit <yuyichao@mit.edu>
Date: Thu, 23 Jun 2011 09:32:38 -0400
X-Google-Sender-Auth: _xM4WnUwp5q8qyHucj3lHnh5mMw
Message-ID: <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
Subject: Re: extra slash in current path
To: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 9:31 AM, Lars Täuber <taeuber@bbaw.de> wrote:
> Hi,
>
> Am Thu, 23 Jun 2011 09:14:18 -0400
> yuyichao-mit <yuyichao@mit.edu> schrieb:
>> The problem is like this:
>>
>> $ cd /
>> $ pwd
>> /
>>
>> $ cd /
>> $ pwd
>> //
>
> didn't you mean?:
> $ cd //
> $ pwd
> //

yes, exactly.

Sorry for the typo (copy-paste~~~)

>
>
> Regards
> Lars
>
>>
>> $ cd ///
>> $ pwd
>> /
>>
>> Why can there be a extra slash (and exactly one) in current path? Is
>> this designed on purpose?
>> This is not really a big deal but I think it can confuse some program.
>>
>> Thanks.
>>
>> Yichao
>
