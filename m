Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1DQKMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 06:12:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49254 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1DQKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 06:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HsK5/KhjfHtbD3q2okCCR8lCAvPk8RAuqV1+rZ0oXydtp5L/DxOLFcsguBAhR8j0RR
         ie+M4Hm/Fb1dYMJ6ur5RXDGdnQx7zX6s/htJ+wsA9vLOS3HBEqIEogFdz+hLd0TDIVDV
         JmMr5olHfAWJ0ijmhAC4/3m+W2uT2RRV3s5sE=
Message-ID: <4DAABCE9.4000903@gmail.com>
Date: Sun, 17 Apr 2011 18:11:53 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: jiaweiwei.xiyou@gmail.com
CC: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] drivers:regulator:change debug statement be consistent
 with the style of the rest.
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com> <20110416175440.GD25811@opensource.wolfsonmicro.com> <4DAA3A25.30501@gmail.com> <20110417091918.GA3509@gmail.com>
In-Reply-To: <20110417091918.GA3509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  2011-4-17 17:19, Harry Wei wrote:
> On Sun, Apr 17, 2011 at 08:53:57AM +0800, Wanlong Gao wrote:
>>
>>
>> change the "mc13783_regulator_probe" string in the function
>> "mc13783_regulator_probe"
>> to "__func__" for the debug statement be consistent with the style
>> of the rest of
>> the file.
>>
>> Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
>> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Hi Wanlong,
> 	I really wanna know have Mark given this patch a 'Acked-by'.
> Because you are the first one, who sent this patch. Of course, Mark
> maybe your workmate or else.
> 	I am so sorry for this silly question :) but i am curious
> about it.
>
> Thanks.
> Harry Wei.
It just a resend patch which had already acked-by Make.
You had missed my patch before .
Thanks
