Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0ENAV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:21:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46861 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0ENAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GOw/BVjDG03nuDLsbUN8csps20eAM+FFawaBj2gzRTij0bFBDJ+JlARj5stFyEi8DC
         8UdhjyfHgfAZ/FogI7zUFiIxja/BiTZ5sibT2gtA2o6gUV+RQnZfp/nsyUBpT+q/s+EN
         3eMsK6A2ZrlJUurMP11YdJASNSrseZTjU2spw=
Message-ID: <4BEC9782.2040705@gmail.com>
Date: Thu, 13 May 2010 17:21:22 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
In-Reply-To: <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/10 16:01, Luis R. Rodriguez wrote:
> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> not sure what this is, but while at a convention
>> I was trying to access the internet and(below is
>> full dmesg) this showed up.
>>
>> After receiving this, I sat and tried to re-create
>> my steps to reproduce but had no luck(was even going
>> todo a bisect n the spot if I could re-create).
>
> OK this stuff is hard to reproduce it seems.. you have an Atheros
> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
> to get the poison stuff? I am just surprised we haven't seen it
> ourselves yet. Let me make sure all of us get this kconfig option
> enabled.
>
>    Luis
>



CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUGFS is not set

if you need my .config let me know.
(I can try again reproducing, but man
just doesn't easily fire off).

Justin P. Mattock
