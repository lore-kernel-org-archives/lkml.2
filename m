Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1HSRER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:04:17 -0400
Received: from void.printf.net ([89.145.121.20]:39750 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1HSREO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:04:14 -0400
From: Chris Ball <cjb@laptop.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mmc@vger.kernel.org,
        "'linux-arm-kernel\@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mmc: atmel rework for next
References: <4E4A8E73.7050705@atmel.com>
Date: Fri, 19 Aug 2011 13:03:47 -0400
In-Reply-To: <4E4A8E73.7050705@atmel.com> (Nicolas Ferre's message of "Tue, 16
	Aug 2011 17:36:19 +0200")
Message-ID: <m24o1dnxjg.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 16 2011, Nicolas Ferre wrote:
> Hi Chris,
>
> Please pull from:
>
> git://github.com/at91linux/linux-2.6-at91.git nfe/mmc_atmel
>
> This is a series that reworks the atmel-mci driver for a future merge of both at91_mci and atmel-mci drivers. Those patches have been discussed on the mailing-list.
> I added a tiny at91_mci patch also sent last week.

Thanks, all looks good -- pushed to mmc-next with some commit message
rewording.  Please wrap your commit messages to 75 cols in future, so
that they're viewable in "git log" without wrapping.

I'll repeat your warning text from one of the commit messages here for
the broader audience:

    Warning: at91rm9200 is not supported, to support it we need to use
    swab32 on data but I have no board to test it.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
