Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0IWQzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:55:15 -0400
Received: from mail.wdtv.com ([66.118.69.84]:46867 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0IWQzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:55:14 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Add mkcis - a program that can create .cis from text description
Date: Thu, 23 Sep 2010 12:55:09 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; i686; ; )
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com> <1285255197-9262-2-git-send-email-dbaryshkov@gmail.com> <1285255752.10687.20.camel@i7.infradead.org>
In-Reply-To: <1285255752.10687.20.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009231255.09443.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 23, 2010, David Woodhouse wrote:
>On Thu, 2010-09-23 at 19:19 +0400, Dmitry Eremin-Solenikov wrote:
>> For CIS files (describing hardware on PCMCIA and some other busses)
>> binary file isn't the 'preferred for for modification' in most cases.
>> pcmcia-cs project have developed pack_cis program which can be used
>> (and was used most probably) to generate .cis files from simple text
>> descriptions. Import this code to the kernel under the name of mkcis.
>
>This is useful, thanks -- but NACK. The firmware/ directory of the
>kernel will hopefully die soon, and is no longer what's actually shipped
>by many distributions.
>
>We should be concentrating on the linux-firmware.git repository instead.

Unfortunately, a perusal of that git repo fails to find the amd-microcode 
tree, which contains a .bin file that brings my early 4 core phenom up to 
revision 65.

I picked that up and have been carrying it forward from a message's link 
from this list about 2 years ago, and have been carrying it locally since.  
However, I have not seen it mentioned as being used in a dmesg parse since 
2.6.35-early-rc.

Is there a good reason for this late apparent lack of using this resource?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If Microsoft built cars, If you were involved in a crash, you would have
no idea what happened.
