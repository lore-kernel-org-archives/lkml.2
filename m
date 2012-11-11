Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab2KKI6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 03:58:55 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:58482 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2KKI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 03:58:54 -0500
Date: Sun, 11 Nov 2012 09:58:41 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
Message-ID: <20121111095841.285784c0@skate>
In-Reply-To: <1352590084.14983.1.camel@phoenix>
References: <1352590084.14983.1.camel@phoenix>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Sun, 11 Nov 2012 07:28:04 +0800, Axel Lin wrote:
> Current implementation in dove_audio1_ctrl_set() does not clear corresponding
> register bit if BIT(0|1|2|3) of config is clear. Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> I don't have this hardware.
> I'd appreciate if someone can review and test this patch.
> 
> Thanks,
> Axel
>  drivers/pinctrl/mvebu/pinctrl-dove.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)

The patches against pinctrl-dove need to be reviewed and acked by
Sebastian Hesselbarth, he is the one who has written this code and who
has access to Dove hardware. Could you repost and Cc him, as well as
linux-arm-kernel@ ?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
