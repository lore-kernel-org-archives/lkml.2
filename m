Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab1CIAld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:41:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37945 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1CIAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gvI4taYmBspGJnkPzq1Ktu0Tm8x/PEkCmrRxYSVGEJcmTqBj2M2K/ZNoBITi91OAbI
         fizyJ2XeGV+2+sQee15vJZsFnLfXiCATACtGpmAWbboI2S3sjm6xNoahyuKT+AZ4rHHz
         505jWBeN378NM/Vxaf869kvPjcq1XfaXZFV5Y=
MIME-Version: 1.0
In-Reply-To: <20110309000932.GA12470@kroah.com>
References: <4D75D338.9070801@samsung.com>
	<20110308135909.GA7519@kroah.com>
	<AANLkTi=cgOJK=xGpbM8zaTVHcF+ZzjTCds+6dw3zAN_P@mail.gmail.com>
	<20110309000932.GA12470@kroah.com>
Date: Wed, 9 Mar 2011 09:41:30 +0900
Message-ID: <AANLkTikvCvkSdOCTGVT_C7sWemzG8g_+fsSy_PQkwCfO@mail.gmail.com>
Subject: Re: [PATCH v3] misc: adds support the FSA9480 USB Switch
From: Minkyu Kang <promsoft@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg KH,

On 9 March 2011 09:09, Greg KH <greg@kroah.com> wrote:
> On Wed, Mar 09, 2011 at 08:59:18AM +0900, Minkyu Kang wrote:
>> Dear Greg KH,
>>
>> On 8 March 2011 22:59, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Mar 08, 2011 at 03:56:56PM +0900, Minkyu Kang wrote:
>> >> --- /dev/null
>> >> +++ b/include/linux/fsa9480.h
>> >
>> > Why do you need a .h file for this driver?
>> >
>> > If it's just for platform data, please put it in
>> > include/linux/platform_data/ instead.
>>
>> Yes, it's for platform data.
>> But, sorry I couldn't find such a directory.
>> Where?
>
> It's in the linux-next tree, you can create that file in your patch.
>
OK. I'll move it.

Thanks
Minkyu Kang
-- 
from. prom.
www.promsoft.net
