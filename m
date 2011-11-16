Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1KPBXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:23:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53116 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab1KPBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <6f82953de3539a33c4c5499cd7310ed54528f118.1321398814.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
	<6f82953de3539a33c4c5499cd7310ed54528f118.1321398814.git.joe@perches.com>
Date: Wed, 16 Nov 2011 10:23:05 +0900
Message-ID: <CAKYAXd_RZHH+zcvUBLyeFnXJstx7+AWF0GmZetX1cjw1qFi1Zw@mail.gmail.com>
Subject: Re: [PATCH 2/4] wbsd: Use current logging
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Pierre Ossman <pierre@ossman.eu>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/16 Joe Perches <joe@perches.com>:
> Add pr_fmt.
> Remove DRIVER_NAME from logging calls.
> Remove DBG, use pr_debug.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
