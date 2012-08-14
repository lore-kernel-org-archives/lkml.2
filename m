Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2HNLJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:09:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39201 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab2HNLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-9-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:09:33 +0200
Message-ID: <CACRpkdZtfmsSUxn91ebArALT6gyTg_59EcRhqZVzP=Ff11dhYw@mail.gmail.com>
Subject: Re: [PATCH 08/22] ASoC: codecs: Enable AB8500 CODEC for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ola LILJA2 <ola.o.lilja@stericsson.com>,
        Ola Lilja <olalilja@yahoo.se>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> We continue to allow the AB8500 CODEC to be registered via the AB8500
> Multi Functional Device API, only this time we extract its configuration
> from the Device Tree binary.
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Also for Ola to look at, and/or ACK.
I dare not even ACK patches like this.

Yours,
Linus Walleij
