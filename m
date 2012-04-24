Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2DXNWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:22:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50809 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2DXNWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <0LgtFa-1RqHgs3C6g-00neuS@mrelayeu.kundenserver.de>
References: <0LgtFa-1RqHgs3C6g-00neuS@mrelayeu.kundenserver.de>
Date: Tue, 24 Apr 2012 15:22:49 +0200
Message-ID: <CACRpkdZvgS7o1ARU4199yFaWG6XLExzbqjJP2vxgG1x6knZVUg@mail.gmail.com>
Subject: Re: [PATCH] GPIO: Add support for TI TCA6424
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 9:32 AM, Andreas Schallenberg
<Andreas.Schallenberg@3alitytechnica.com> wrote:

> This patch extends the PCA953x driver to support TI's TCA6424.
> It is based on code by Michele Bevilacqua. Please review.

Please send patches inline and not as attachments.

Consider git send-email ...

Yours,
Linus Walleij
