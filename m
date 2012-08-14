Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2HNIco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:32:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33662 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2HNIcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:32:38 +0200
Message-ID: <CACRpkdb2O4wTei75dnDnszzg7u1JMJZkkH3xs_34rVaQxW1zYw@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Match Power-On-Key MFD and DTS compatible strings
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The compatible string found in the Power-On-Key's MFD cell matches
> the device name provided in the driver. Keeping this naming convention
> seems like a good idea, so we're changing the one found in the DTS
> file to match.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
