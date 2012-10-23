Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2JWHe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:34:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60260 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab2JWHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:34:55 -0400
X-Auth-Info: 1rw/gQnIk/+FqxFdNgD0VZ9O4hmQi6sua9Y2tZmTvDA=
From: Marek Vasut <marex@denx.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/4] backlight: lms283gf05: add missing const
Date: Tue, 23 Oct 2012 09:34:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
References: <000a01cdb0d5$9d764970$d862dc50$%han@samsung.com>
In-Reply-To: <000a01cdb0d5$9d764970$d862dc50$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210230934.51274.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

> Add 'const' to static array that was missing it in its
> definition.

Did you get compiler warning? Still, this is a good pick

Acked-by: Marek Vasut <marex@denx.de>

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
[...]

Best regards,
Marek Vasut
