Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab2KWHe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:34:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46164 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab2KWHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <1353048646-10935-8-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	<1353048646-10935-8-git-send-email-tushar.behera@linaro.org>
Date: Fri, 23 Nov 2012 08:34:27 +0100
Message-ID: <CACRpkdbQ6T842-vfzEgjSK_Kv-SM=w1yOFXtxqkRpiU9nNmsUg@mail.gmail.com>
Subject: Re: [PATCH 07/14] pinctrl: SPEAr: Update error check for unsigned variables
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 7:50 AM, Tushar Behera <tushar.behera@linaro.org> wrote:

> Checking '< 0' for unsigned variables always returns false. For error
> codes, use IS_ERR_VALUE() instead.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Patch applied with Viresh's ACK, thanks!
Linus Walleij
