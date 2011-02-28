Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1B1PSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:18:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab1B1PSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:18:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guan Xuetao <epip@hera.kernel.org>
Subject: Re: [PATCH 15/17] unicore32 machine related: add frame buffer driver for pkunity-v3 soc
Date: Mon, 28 Feb 2011 16:18:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1298821856.git.epip@hera.kernel.org> <a336d8ba89b5afe129cb9178f26216b22d6beb63.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <a336d8ba89b5afe129cb9178f26216b22d6beb63.1298821856.git.epip@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281618.03890.arnd@arndb.de>
X-Provags-ID: V02:K0:RQttIaGc0KgjZ9OIB6LJHM8s9skQ4nUktRlsWNFG2+T
 qiJtWb80MBHQn7769CFovGyYwYJLjeswFQJGANZaPx7hzObMS6
 KEYcQiv3W2+jlpqavO4GC+bknDDI9H9119C743BcIitT7r1J4i
 wQA9C3GYcxXoUCSCIQT9ebXOedxXKj2xWxEU2Ee5xjD/AGBv+L
 EN2oQAhPoxpYGkscvJsdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> 
> change from original version -- by advice of Paul Mundt
> 1. remove videomemorysize definitions
> 2. remove unifb_enable and unifb_setup
> 3. use dev_warn instead of printk in fb driver
> 4. remove judgement for FB_ACCEL_PUV3_UNIGFX
> 5. adjust clk_get and clk_set_rate calls
> 6. add resources definitions
> 7. remove unifb_option
> 8. adjust register for platform_device
> 9. adjust unifb_ops position and unifb_regs assignment position
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
