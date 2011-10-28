Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1J1UhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:37:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35752 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1J1UhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:37:01 -0400
Message-ID: <4EAB126A.5090507@garzik.org>
Date: Fri, 28 Oct 2011 16:36:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, olof@lixom.net, ben@decadent.org.uk,
        arnaud.patard@rtp-net.org, grant.likely@secretlab.ca,
        w.sang@pengutronix.de, bs14@csr.com
Subject: Re: [PATCH] ARM: mark empty gpio.h files empty
References: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 04:19 PM, Linus Walleij wrote:
> It is generally a better idea to make intentionally empty files
> contain the human-readable /* empty */ comment, also it makes
> the files play nice with "make distclean".
>
> Reported-by: Jeff Garzik<jeff@garzik.org>
> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>

Thanks!

Acked-by: Jeff Garzik <jgarzik@redhat.com>



