Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1HZOvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:51:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HZOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:51:43 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] p54spi: add "spi:" prefix for stlc45xx modalias
Date: Fri, 26 Aug 2011 16:51:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc3-wl+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1314340499.25655.1.camel@phoenix>
In-Reply-To: <1314340499.25655.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261651.29640.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 26, 2011 08:34:59 AM Axel Lin wrote:
> Since commit e0626e38 (spi: prefix modalias with "spi:"),
> the spi modalias is prefixed with "spi:".
> 
> This patch adds "spi:" prefix for modalias of stlc45xx.
> Also move it to be group with other modalias.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
sure, can't say no.
Acked-By: Christian Lamparter <chunkeey@googlemail.com>
