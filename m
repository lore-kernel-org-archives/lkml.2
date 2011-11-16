Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab1KPBSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:18:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35204 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab1KPBSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:18:53 -0500
MIME-Version: 1.0
In-Reply-To: <c75784ed1efa8636f7177cd5662c35fa6a8d03df.1321398814.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
	<c75784ed1efa8636f7177cd5662c35fa6a8d03df.1321398814.git.joe@perches.com>
Date: Wed, 16 Nov 2011 10:18:52 +0900
Message-ID: <CAKYAXd_gSohnAc9tpK53bjpoeSJ=0fMWz38SeLzHtRzvGTNgGQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mmc: Update logging style
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>,
        Alex Dubov <oakad@yahoo.com>, Pierre Ossman <pierre@ossman.eu>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/16 Joe Perches <joe@perches.com>:
> Convert pr_warning to pr_warn.
> Coalesce format strings.
> Align arguments.
> Add missing \n.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
