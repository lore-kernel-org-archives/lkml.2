Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2GDXun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 19:50:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63615 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2GDXui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 19:50:38 -0400
MIME-Version: 1.0
In-Reply-To: <1341409019-32166-1-git-send-email-ohad@wizery.com>
References: <1341409019-32166-1-git-send-email-ohad@wizery.com>
Date: Thu, 5 Jul 2012 01:50:37 +0200
Message-ID: <CACRpkdYr4VFpSLhcy3vst4=ZzTVPG8OKiZvLb_z4VmKmJGrQeg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: adopt the driver core's alloc/add/del/put naming
From: Linus Walleij <linus.walleij@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 3:36 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> To make remoteproc's API more intuitive for developers, we adopt
> the driver core's naming, i.e. alloc -> add -> del -> put. We'll also
> add register/unregister when their first user shows up.
>
> Otherwise - there's no functional change here.
>
> Suggested by Russell King <linux@arm.linux.org.uk>.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

I understand this patch and it's a good thing, so:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
