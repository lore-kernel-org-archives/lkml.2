Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2GFHKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:10:12 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38874 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GFHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-5-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-5-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:10:08 +0200
Message-ID: <CACRpkdaM1J_iotK_mwXqAznQgRGMF=feZM7tK_rgcEbOrQkC5w@mail.gmail.com>
Subject: Re: [PATCH 4/9] ARM: ux500: Ensure vendor specific properties have
 the vendor's identifier
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Any non-standard property should contain the vendor's identifier which
> should be perpended onto the property name followed by a comma. This
> aids in name-space collision prevention.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
