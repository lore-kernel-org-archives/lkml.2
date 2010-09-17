Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0IQSd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:33:57 -0400
Received: from mail.tpi.com ([70.99.223.143]:2392 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab0IQSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:33:56 -0400
Message-ID: <4C93B486.8050706@canonical.com>
Date: Fri, 17 Sep 2010 12:33:42 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Brett Rudley <brudley@broadcom.com>
CC: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: Make CFLAGS explicit
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com> <20100917162142.GA30385@suse.de> <4C93A8F9.9090108@canonical.com> <7A94256FD72B884D9E7C55586C3CBCEE12BEC65BEC@SJEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE12BEC65BEC@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 12:03 PM, Brett Rudley wrote:
>
> In a split mac dongle, the HIGH code runs on the host processor while
> the LOW code runs on the dongle and the two talk across an RPC API
> over SDIO or USB.
>

Don't you have the orientation inverted? WLC_LOW is defined for a PCI NIC.

> On a NIC both HIGH and LOW run on the host and the RPC API remains
> identical but the APIs become function straight calls.
>

I'm a bit confused by this. For PCI NICs WLC_HIGH_ONLY is definitely 
_not_ enabled, which means to me that HIGH is not running on the host.

> This lets us use the same code and API in both models.
>
> Getting some documentation out on this is in TODO list.
>

Thanks. Perhaps that'll clear up some confusion.

> Brett

-- 
Tim Gardner tim.gardner@canonical.com
