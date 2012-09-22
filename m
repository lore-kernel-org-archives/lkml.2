Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2IVKjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 06:39:05 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:43414 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab2IVKi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 06:38:59 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <54116.162.105.203.8.1348310959.squirrel@mprc.pku.edu.cn>
In-Reply-To: <20120922073207.GB2538@avionic-0098.mockup.avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
    <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
    <50847.162.105.203.8.1348282590.squirrel@mprc.pku.edu.cn>
    <20120922073207.GB2538@avionic-0098.mockup.avionic-design.de>
Date: Sat, 22 Sep 2012 18:49:19 +0800 (CST)
Subject: Re: [PATCH v2 2/5] unicore32: pwm: Use module_platform_driver()
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: guanxuetao@mprc.pku.edu.cn, "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        "Qin Rui" <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Sep 22, 2012 at 10:56:30AM +0800, guanxuetao@mprc.pku.edu.cn
> wrote:
>> > Some of the boilerplate code can be eliminated by using this macro.
>> The
>> > driver was previously registered with an arch_initcall(), so
>> technically
>> > this is no longer the same, but when the driver is moved to the PWM
>> > framework, deferred probing will take care of any driver probe
>> ordering
>> > issues.
>> >
>> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>
>> Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
>> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>>
>> Thanks & Regards,
>> Guan Xuetao
>
> Great! If you don't mind I'll take this through the PWM tree with your
> Acked-by.
>
> Thierry
>

It's my pleasure.

Thanks & Regards,
Guan Xuetao
