Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2A0VfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:35:06 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:13052
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752836Ab2A0VfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:35:04 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh6d523hz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F231877.9050504@freescale.com>
Date: Fri, 27 Jan 2012 15:34:47 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0.1) Gecko/20111221 Firefox/9.0.1 SeaMonkey/2.6.1
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: <linux-watchdog@vger.kernel.org>, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: fix GETTIMEOUT ioctl in booke_wdt
References: <1327605870-9226-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1327605870-9226-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Artamonow wrote:
> Commit dcfb748422 ([WATCHDOG] fix book E watchdog to take
> WDIOC_SETTIMEOUT arg in seconds) fixed SETTIMEOUT ioctl
> to use seconds as a parameter instead of some hardware-specific
> "period", but missed to apply similar changes to GETTIMEOUT,
> so it still returns "period" value. Let's fix it!
> Also, while at it, make SETTIMEOUT ioctl return real timeout
> value as it should do according to the documentation.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---

Acked-by: Timur Tabi <timur@freescale.com>

I don't have an easy way to test the watchdog ioctls.

-- 
Timur Tabi
Linux kernel developer at Freescale

