Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2DIXEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:04:41 -0400
Received: from na3sys009aob129.obsmtp.com ([74.125.149.136]:48814 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752044Ab2DIXEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120409222903.GA31622@lunn.ch>
References: <20120409222903.GA31622@lunn.ch>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 9 Apr 2012 16:04:16 -0700
Message-ID: <CAJOA=zP8XFTN1mcAyUky3ovrx4Dg1zb9zaB5r8zUYE46Ec-tMQ@mail.gmail.com>
Subject: Re: COMMON_CLK_DISABLE_UNUSED
To: mturquette@linaro.org, arnd.bergmann@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:29 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> I think it would be good to consider deleting this config option and
> just have the code always enabled.

I agree.  We already support the CLK_IGNORE_UNUSED flag, so any
platforms that don't want this functionality wholesale can set that
bit for every clock.

I'll pull out that option.

Regards,
Mike
