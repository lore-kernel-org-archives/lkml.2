Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2K2UEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:04:25 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43395 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2K2UEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:04:24 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Chao Xie <chao.xie@marvell.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: Re: [PATCH 2/4] rtc: pxa: fix rtc caculation issue
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<1354155670-6267-2-git-send-email-chao.xie@marvell.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 29 Nov 2012 21:04:06 +0100
In-Reply-To: <1354155670-6267-2-git-send-email-chao.xie@marvell.com> (Chao
	Xie's message of "Wed, 28 Nov 2012 21:21:08 -0500")
Message-ID: <87r4nc18i1.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chao Xie <chao.xie@marvell.com> writes:

Hi Chao Xie,

First of all, could you please send patches from rtc-pxa to me also, as I'm
maintaining that driver ?

Second point, the original design of the driver relies on the special case of
writing zeroes to WOM and DOM, as mentionned in PXA27x Developers Guide, chapter
21.4.2.3.5 "Writing Alarm Registers with Invalid (Zero) Data", which states :
> Day-Of-Week (DOW), or Week-Of-Month (WOM), Day of Month (DOM), Month or Year
> fields—Zero is not valid for these fields. If zero is written into any of
> these fields, it is ignored while generating the alarm.

I'd like to know if your patch fixes something, or is an enhancement ?

Cheers.

--
Robert

PS: I've not checked the patch yet, that's just a prelimary comment on the patch
message.
