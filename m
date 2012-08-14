Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2HNIkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:40:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58386 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2HNIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-3-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:40:09 +0200
Message-ID: <CACRpkdZ9XBTx_MQ9eDN_wOpeAXVt2REa7yr4ngd-0MDhsvZN3w@mail.gmail.com>
Subject: Re: [PATCH 02/22] ARM: ux500: Ensure probing of Audio devices when
 Device Tree is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Previous attempts to add platform probing of the Audio related devices
> only call from non-DT initialisation functions. This patch extends that
> functionality to the Device Tree related ones too.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to ux500 fixes. Will send upstream for the -rc:s.

Yours,
Linus Walleij
