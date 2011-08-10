Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1HJC2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:28:41 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:57183 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991Ab1HJC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:28:39 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Joe Perches <joe@perches.com>
To: stufever@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <1312943399-14435-1-git-send-email-wangshaoyan.pt@taobao.com>
References: <1312943399-14435-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 19:28:36 -0700
Message-ID: <1312943316.11924.54.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:29 +0800, stufever@gmail.com wrote:
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
[]
> diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
[]
> @@ -686,10 +686,21 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
[]
> +	if (!local_rqfpr || !local_rqfcr) {
> +		pr_err("Out of memory\n");
> +		ret = 0;
> +		got err;

"got err" is true.

Please compile test your patches before sending them.


