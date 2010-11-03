Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0KCHoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:44:37 -0400
Received: from stinky.trash.net ([213.144.137.162]:44500 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0KCHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:44:36 -0400
Message-ID: <4CD112E2.3040800@trash.net>
Date: Wed, 03 Nov 2010 08:44:34 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: netfilter: arp_tables: fix information leak to
 userland
References: <1288448806-6470-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1288448806-6470-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.10.2010 16:26, Vasiliy Kulikov wrote:
> Structure arpt_getinfo is copied to userland with the field "name"
> that has the last elements unitialized.  It leads to leaking of
> contents of kernel stack memory.

Applied, thanks.
