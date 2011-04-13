Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1DMNSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:18:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1DMNSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I6AaF0PGUJ7yZuABXsvvTH9Gf6CxUrZ/MQymJWvINO98a9zSa8Vh7gGROp9c9ekiDO
         KIpsxsa65taPXzRc6pMJhS2HZyDuxH67LMvUnMgg3qn102M1MNzSigEFjlDvH+apNgP3
         qir01bM47TRIPYbdRfp6VEoI1u0YFsJJuVHJc=
Message-ID: <4DA5A298.9060609@gmail.com>
Date: Wed, 13 Apr 2011 21:18:16 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: chris@zankel.net, steiner@sgi.com, tglx@linutronix.de,
        akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fix the wrong argument of the functions definition
References: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>	 <1302416084-13372-2-git-send-email-wanlong.gao@gmail.com> <1302700440.10549.1.camel@hcegtvedt>
In-Reply-To: <1302700440.10549.1.camel@hcegtvedt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011-4-13 21:14, Hans-Christian Egtvedt 写道:
> On Sun, 2011-04-10 at 14:14 +0800, wanlong.gao@gmail.com wrote:
>> From: Wanlong Gao<wanlong.gao@gmail.com>
>>
>> The functions of eic_chip's memebers use the wrong argument .
>>
>> Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
>
> Thanks for this fix, added to the AVR32 tree.
>
Thanks for your hard work to the open-source .
> Signed-off-by: Hans-Christian Egtvedt<hans-christian.egtvedt@atmel.com>
>
> <snipp patch>
>

