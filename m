Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1KUSwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:52:34 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2627 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946Ab1KUSwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:52:33 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4ECA9DE0.4080202@broadcom.com>
Date: Mon, 21 Nov 2011 10:52:16 -0800
From: "Franky Lin" <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929
 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Thomas Meyer" <thomas@m3y3r.de>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: smac: Use kmemdup rather than
 duplicating its implementation
References: <1321569820.1624.289.camel@localhost.localdomain>
In-Reply-To: <1321569820.1624.289.camel@localhost.localdomain>
X-WSS-ID: 62D440495WO1587936-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 02:43 PM, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
>
> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
> ---

Thanks Thomas.

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky

