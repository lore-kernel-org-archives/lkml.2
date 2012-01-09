Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2AIKBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:01:39 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4327 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2AIKBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:01:38 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4F0ABAEB.5070306@broadcom.com>
Date: Mon, 9 Jan 2012 11:01:15 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Jesper Juhl" <jj@chaosbits.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alwin Beukers" <alwin@broadcom.com>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH] brcm80211: Don't leak 'vbuffer' in
 brcmf_sdbrcm_write_vars()
References: <alpine.LNX.2.00.1201082338350.24030@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1201082338350.24030@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 6314635950411883529-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 11:41 PM, Jesper Juhl wrote:
> If the memory allocation 'nvram_ularray = kmalloc(varsize,
> GFP_ATOMIC);' fails we'll leak the memory allocated to 'vbuffer' when
> we return -ENOMEM from the function.
> 
> This patch resolves the leak by kfree()'ing the allocated memory
> before the return.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Nice catch. Thanks.

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS

