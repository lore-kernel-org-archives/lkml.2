Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2KVSn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:43:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19985 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab2KVSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:43:56 -0500
Message-ID: <50AE11BA.4030803@parallels.com>
Date: Thu, 22 Nov 2012 15:51:22 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: netdev@vger.kernel.org, criu@openvz.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipv6: adapt connect for repair move
References: <1353582838-18876-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1353582838-18876-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 03:13 PM, Andrey Vagin wrote:
> This is work the same as for ipv4.
> 
> All other hacks about tcp repair are in common code for ipv4 and ipv6,
> so this patch is enough for repairing ipv6 connections.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

> ---
>  net/ipv4/tcp_ipv4.c   | 13 +------------
>  net/ipv4/tcp_output.c |  5 +++++
>  net/ipv6/tcp_ipv6.c   |  2 +-
>  3 files changed, 7 insertions(+), 13 deletions(-)
