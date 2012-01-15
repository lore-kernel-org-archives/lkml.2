Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2AOJSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:18:10 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3048 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2AOJSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:18:06 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4F1299C4.7020902@broadcom.com>
Date: Sun, 15 Jan 2012 10:17:56 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Henry Ptasinski" <henryp@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Kan Yan" <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/8] brcm80211: Add and use brcmX_dbg_dump_hex
References: <cover.1326616556.git.joe@perches.com>
 <289e8a2dcdbb03315ba41788a358f5afc4bacb1b.1326616556.git.joe@perches.com>
In-Reply-To: <289e8a2dcdbb03315ba41788a358f5afc4bacb1b.1326616556.git.joe@perches.com>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 630C44413GG19186848-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2012 09:38 AM, Joe Perches wrote:

> +#ifdef DEBUG
> +extern __printf(3, 4)

Just curious if I can learn something here. What does the __printf(3, 4) do?

> +void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...);
> +#else
> +__printf(3, 4)
> +static inline
> +void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
> +{
> +}
> +#endif
> +
>  #endif				/* _BRCMU_UTILS_H_ */

Gr. AvS

