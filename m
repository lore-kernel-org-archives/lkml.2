Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1JXNgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:36:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60446 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab1JXNgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <1319462786-2602-1-git-send-email-jhbird.choi@gmail.com>
References: <1319462786-2602-1-git-send-email-jhbird.choi@gmail.com>
Date: Mon, 24 Oct 2011 21:36:16 +0800
Message-ID: <CAN1soZwd=die3XwY5hjse+q+XOkGNtGVh0zWEGrejBw67_2hKA@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: max8649 Convert max8649 to use regmap api
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: jhbird.choi@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 9:26 PM,  <jhbird.choi@gmail.com> wrote:
> From: Jonghwan Choi <jhbird.choi@gmail.com>
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>
> ---
>  drivers/regulator/Kconfig   |    1 +
>  drivers/regulator/max8649.c |  155 +++++++++++++++----------------------------
>  2 files changed, 56 insertions(+), 100 deletions(-)

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
