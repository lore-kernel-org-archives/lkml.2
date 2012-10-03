Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab2JCQsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:48:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2JCQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:47:44 -0400
Message-ID: <506C6C2A.2060203@gmail.com>
Date: Wed, 03 Oct 2012 09:47:38 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/25] MIPS: Octeon: use OHCI platform driver
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-20-git-send-email-florian@openwrt.org>
In-Reply-To: <1349276601-8371-20-git-send-email-florian@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 08:03 AM, Florian Fainelli wrote:
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>   arch/mips/cavium-octeon/octeon-platform.c |   37 ++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
>

NACK.

Same reason as for the EHCI one (09/25):

OCTEON uses device tree now (or as soon as I send in the corresponding 
patches), so this would just be churning the code.

David Daney

