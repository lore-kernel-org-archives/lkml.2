Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2KMOda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:33:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52358 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2KMOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:33:29 -0500
MIME-Version: 1.0
In-Reply-To: <1352702750.15066.4.camel@phoenix>
References: <1352702750.15066.4.camel@phoenix>
Date: Tue, 13 Nov 2012 15:33:28 +0100
Message-ID: <CACRpkdbMPokEH80WX+M8yvAWAM-XGend3cts4K0eaj=oke8rLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pxa3xx: Use devm_request_and_ioremap
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 7:45 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Use managed resources API to simplify the code.
> Also ensure we do request mem_region before ioremap.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Obviously correct, patch applied.

Yours,
Linus Walleij
