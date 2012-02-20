Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2BTOB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:01:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65080 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2BTOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:01:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.60.7.40 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <B567DBAB974C0544994013492B949F8E3813076551@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3813076551@EXMAIL03.scwf.nsc.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 20 Feb 2012 22:01:05 +0800
Message-ID: <CAF+7xWmMW2BjjtpS34286YaTLf37Ly8Ed0r4jy4NjWY9SYAMqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lp855x-bl: remove unnecessary platform data
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/20 Kim, Milo <Milo.Kim@ti.com>:
> All lp855x devices have 8-bits brightness contorl register.
> The value of max_brightness is set to 255.
> So the max_brightness in the platform data is unnecessary.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> Cc: Axel Lin <axel.lin@gmail.com>
Acked-by: Axel Lin <axel.lin@gmail.com>
