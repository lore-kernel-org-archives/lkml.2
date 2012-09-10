Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2IJJ5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:57:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65224 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2IJJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-9-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-9-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 02:57:39 -0700
Message-ID: <CACRpkdY3_YPwTNmAt9cGjFDKD4ssxOKUmurUrV2O=A7pib040g@mail.gmail.com>
Subject: Re: [PATCH 08/19] ARM: ux500: Stop registering Audio devices for HREF
 when DT is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For this patch alone (because I see what it does) but I think there
are deep deps on earlier patches, some not even in this patch
set, that need to be ACKed by the audio people.

Yours,
Linus Walleij
