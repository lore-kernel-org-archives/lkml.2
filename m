Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2KGQFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:05:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2KGQFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:05:53 -0500
Message-ID: <1352304345.7614.5.camel@phoenix>
Subject: Re: [PATCH 2/2] pinctrl: lantiq: Staticize ltq_pinctrl_dt_free_map
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 00:05:45 +0800
In-Reply-To: <1352303927.7614.3.camel@phoenix>
References: <1352303879.7614.2.camel@phoenix>
	 <1352303927.7614.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2012-11-07 於 23:58 +0800，Axel Lin 提到：
> It is not referenced outside of this file.

Oh. Both ltq_pinctrl_dt_free_map and ltq_pinctrl_dt_node_to_map are only
used in this file.
I'll resend this patch.

Axel


