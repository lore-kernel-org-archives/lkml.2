Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2JZK0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:26:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46431 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015Ab2JZK0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:26:04 -0400
Message-ID: <508A651C.8090709@ti.com>
Date: Fri, 26 Oct 2012 15:55:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Henrique Camargo <henrique@henriquecamargo.com>
CC: <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <u.kleine-koenig@pengutronix.de>, <nicolas.pitre@linaro.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci: fix the uart number in the comment
References: <1347559476-25363-1-git-send-email-henrique@henriquecamargo.com>
In-Reply-To: <1347559476-25363-1-git-send-email-henrique@henriquecamargo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/2012 11:34 PM, Henrique Camargo wrote:
> The bit 0 of the field is uart0 and the bit 1 is uart1 and so on.
> 
> Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>

Queuing this for v3.8. Added an ARM: prefix to subject line since this
is an arch/arm/ patch. Please take care of this next time on.

Thanks,
Sekhar
