Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2IUIAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:00:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61962 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2IUIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO8G_GzOBKB=pdWgKv5GxnYoSNC2mRVwpHYqz4d648pwkA@mail.gmail.com>
References: <CAPgLHd-ac3JYu4SEQd0pPO-YBW4kM+DqcjHs3QzPdLWqc+CXfw@mail.gmail.com>
	<CAMPhdO8G_GzOBKB=pdWgKv5GxnYoSNC2mRVwpHYqz4d648pwkA@mail.gmail.com>
Date: Fri, 21 Sep 2012 16:00:27 +0800
Message-ID: <CAN1soZxkFXc4o+Yjn1hpmM_WMjH8ULf9LuaWA3D=d1aHj97JrA@mail.gmail.com>
Subject: Re: [PATCH] ARM: mmp: using for_each_set_bit to simplify the code
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:23 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Fri, Sep 14, 2012 at 10:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Using for_each_set_bit() to simplify the code.
>>
>> spatch with a semantic match is used to found this.
>> (http://coccinelle.lip6.fr/)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Great API, this is good. Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
Applied

Thanks
Haojian
