Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2KPLkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:40:03 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18435 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2KPLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:40:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6897"; a="7289917"
X-IronPort-AV: E=McAfee;i="5400,1158,6897"; a="427124760"
Message-ID: <50A62607.4060900@qca.qualcomm.com>
Date: Fri, 16 Nov 2012 13:39:51 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] drivers/net/wireless/ath/ath6kl/hif.c: drop if around
 WARN_ON
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr> <1351974625-10282-9-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1351974625-10282-9-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 10:30 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Just use WARN_ON rather than an if containing only WARN_ON(1).
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, applied to ath6kl.git.

Kalle
