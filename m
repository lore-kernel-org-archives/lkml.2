Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1KNKNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:13:53 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3113 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1KNKNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:13:52 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EC0E9D7.7080304@broadcom.com>
Date: Mon, 14 Nov 2011 11:13:43 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929
 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Use current logging styles
References: <1321213264.15834.4.camel@Joe-Laptop>
In-Reply-To: <1321213264.15834.4.camel@Joe-Laptop>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62DE341B3GG995765-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 08:41 PM, Joe Perches wrote:
> Add and use pr_fmt and pr_<level>
> Remove useless double parentheses from macros.
> Remove function names from format strings, add to pr_debug use.
> Coalesce formats.
> Remove uncompileable undeclared variable in a DMA_NONE use.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   14 +-
>  drivers/net/wireless/brcm80211/brcmsmac/dma.c     |  145 ++++++++++-----------
>  2 files changed, 80 insertions(+), 79 deletions(-)

Thanks for the service.

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


