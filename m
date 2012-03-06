Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2CFQLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:11:00 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47672 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2CFQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:10:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.182.13.8 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
Message-ID: <4F563704.50608@lwfinger.net>
Date: Tue, 06 Mar 2012 10:10:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: awalls@md.metrocast.net, linux-media@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ivtv: Fix build warning
References: <4f53b393.cBPkBHEECVOO9Jzx%Larry.Finger@lwfinger.net> <4F561124.30800@bisect.de>
In-Reply-To: <4F561124.30800@bisect.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 07:29 AM, Danny Kukawka wrote:
> Am 04.03.2012 19:25, schrieb Larry Finger:
>> In driver ivtv, there is a mismatch between the type of the radio module parameter
>> and the storage variable, which leads to the following warning:
>>
>>    CC [M]  drivers/media/video/ivtv/ivtv-driver.o
>> drivers/media/video/ivtv/ivtv-driver.c: In function ‘__check_radio’:
>> drivers/media/video/ivtv/ivtv-driver.c:142: warning: return from incompatible pointer type
>> drivers/media/video/ivtv/ivtv-driver.c: At top level:
>> drivers/media/video/ivtv/ivtv-driver.c:142: warning: initialization from incompatible pointer type
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>
> See my already twice send patches:
> http://thread.gmane.org/gmane.linux.kernel/1246476

Thanks for the link, and the information that the warning is being fixed.

Larry

