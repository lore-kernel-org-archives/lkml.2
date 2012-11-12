Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2KLJjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:39:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43037 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2KLJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:39:25 -0500
Message-ID: <50A0C3C8.2020501@gmail.com>
Date: Mon, 12 Nov 2012 10:39:20 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
References: <1352641495.3113.1.camel@phoenix>
In-Reply-To: <1352641495.3113.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 02:44 PM, Axel Lin wrote:
> Current implementation in dove_audio1_ctrl_set() does not clear corresponding
> register bit if BIT(0|1|2|3) of config is clear. Fix it.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>

Axel,

thanks for the hint on not clearing the audio1 bits before setting them.
I will test this tonight and guess you should prepare a real patch for
this one.

Sebastian
