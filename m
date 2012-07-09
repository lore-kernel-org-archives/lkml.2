Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2GIUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:08:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42399 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2GIUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:08:35 -0400
Message-ID: <4FFB3A3E.6020107@linaro.org>
Date: Mon, 09 Jul 2012 22:08:30 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, Alessandro Rubini <rubini@gnudd.com>,
        linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 0/3] i2c-nomadik changes
References: <cover.1339447570.git.rubini@gnudd.com> <CACRpkdakDBrF+G9wpPn+PQ5tcb2xqeiBoSRMmj_PuB_WhufaaQ@mail.gmail.com> <20120709094821.GB1296@pengutronix.de> <CACRpkda6Bup7myYowaLHnAMd5wkUrehYaJnu7BRnbsOwytZ9sw@mail.gmail.com>
In-Reply-To: <CACRpkda6Bup7myYowaLHnAMd5wkUrehYaJnu7BRnbsOwytZ9sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/12 21:40, Linus Walleij wrote:
> On Mon, Jul 9, 2012 at 11:48 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>> On Mon, Jun 11, 2012 at 11:37:15PM +0200, Linus Walleij wrote:
>>> On Mon, Jun 11, 2012 at 10:56 PM, Alessandro Rubini <rubini@gnudd.com> wrote:
>>>
>>>> V3:
>>>>         - fixed according to Linusw feedback (merged the patch he posted)
>>>>         - added Tested-by: Linusw on his permission
>>>
>>> I'm happy with this version, Wolfram if it looks OK to you,
>>> can you please merge this into the I2C tree?
>>
>> Done now, thanks.
>>
>> Is the latest version of Lee's patches for DT sent on 20/06 suitable to
>> go on top of that?
>
> No clue on that, Lee'd have to comment.

All my i2c stuff is in -next.

Feel free to pull it in and base on that.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


