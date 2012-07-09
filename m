Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2GITkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:40:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46740 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2GITkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120709094821.GB1296@pengutronix.de>
References: <cover.1339447570.git.rubini@gnudd.com>
	<CACRpkdakDBrF+G9wpPn+PQ5tcb2xqeiBoSRMmj_PuB_WhufaaQ@mail.gmail.com>
	<20120709094821.GB1296@pengutronix.de>
Date: Mon, 9 Jul 2012 21:40:06 +0200
Message-ID: <CACRpkda6Bup7myYowaLHnAMd5wkUrehYaJnu7BRnbsOwytZ9sw@mail.gmail.com>
Subject: Re: [PATCH V3 0/3] i2c-nomadik changes
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>, Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 11:48 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Mon, Jun 11, 2012 at 11:37:15PM +0200, Linus Walleij wrote:
>> On Mon, Jun 11, 2012 at 10:56 PM, Alessandro Rubini <rubini@gnudd.com> wrote:
>>
>> > V3:
>> >        - fixed according to Linusw feedback (merged the patch he posted)
>> >        - added Tested-by: Linusw on his permission
>>
>> I'm happy with this version, Wolfram if it looks OK to you,
>> can you please merge this into the I2C tree?
>
> Done now, thanks.
>
> Is the latest version of Lee's patches for DT sent on 20/06 suitable to
> go on top of that?

No clue on that, Lee'd have to comment.

Yours,
Linus Walleij
