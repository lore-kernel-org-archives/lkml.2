Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2KELoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:44:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61305 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2KELoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <1351863973.2970.1.camel@phoenix>
References: <1351863973.2970.1.camel@phoenix>
Date: Mon, 5 Nov 2012 12:44:17 +0100
Message-ID: <CACRpkdYLw8DgCn5GQqNgNJ6fbvLqODSmHgu6uP_0KZodUBr8jw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: exynos: Add terminating entry for of_device_id table
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 2:46 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The of_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks Axel, patch applied.

Yours,
Linus Walleij
