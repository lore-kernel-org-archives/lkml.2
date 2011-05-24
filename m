Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1EXPpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:45:13 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:36825 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1EXPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:45:11 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_gpio: support interrupt function
Date: Tue, 24 May 2011 17:45:07 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241745.08302.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 May 2011 04:46:35 Tomoya MORINAGA wrote:
> Support interrupt function.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/gpio/Kconfig    |    2 +-
>  drivers/gpio/pch_gpio.c |  153
> +++++++++++++++++++++++++++++++++++++++++++++++ 2 files changed, 154
> insertions(+), 1 deletions(-)

This patch doesn't apply to v2.6.39. There are some more or less trivial fixes 
needed. But it doesn't compile anyway.

Regards,
Alexander
