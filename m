Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0I2PEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:04:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56779 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0I2PEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vy8Dea6bWfKhHXcng0IYC2xrGQ2T6JkR2eoAywTC2qayHT+kKAenaijqHAFid54o2x
         cZq4KQs0j9ivOrh4sHWzfwXeZsaAnDkYiNds/JERWKHdfnSUKAOq6L/wPlNInMUJUoJL
         2NaF1huqPbmPAgQDPXK24K4DBG564v2OtEdBM=
MIME-Version: 1.0
In-Reply-To: <20100929080052.ceaf6727.rdunlap@xenotime.net>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikXgtFtBE_EM3izNR5H-ug4hhfa19PMvQLftD8s@mail.gmail.com>
	<20100929080052.ceaf6727.rdunlap@xenotime.net>
Date: Wed, 29 Sep 2010 17:04:34 +0200
Message-ID: <AANLkTimE1dU3k9f1v_Zv82Dk=u6xVFf+c_vAxR-zq-Yu@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: Na Pohybel <napohybelskurwysynom2010@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/29 Randy Dunlap <rdunlap@xenotime.net>:
> On Wed, 29 Sep 2010 11:15:32 +0200 N.P.S. N.P.S. wrote:
>
>> 2010/9/29  <akpm@linux-foundation.org>:
>> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
>> >
>>
>>
>> drivers/base/core.c: In function 'get_device_parent':
>> drivers/base/core.c:634: error: 'block_class' undeclared (first use in
>> this function)
>> drivers/base/core.c:634: error: (Each undeclared identifier is
>> reported only once
>> drivers/base/core.c:634: error: for each function it appears in.)
>> drivers/base/core.c: In function 'device_add_class_symlinks':
>> drivers/base/core.c:723: error: 'block_class' undeclared (first use in
>> this function)
>> drivers/base/core.c: In function 'device_remove_class_symlinks':
>> drivers/base/core.c:751: error: 'block_class' undeclared (first use in
>> this function)
>> make[2]: *** [drivers/base/core.o] B³±d 1
>> make[1]: *** [drivers/base] B³±d 2
>> make: *** [drivers] B³±d 2
>
> Patch has been sent to GregKH for this one.
>

Thanks!


-- 
Slawa!
N.P.S.
