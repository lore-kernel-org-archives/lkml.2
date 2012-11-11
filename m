Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KKSUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:20:31 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56769 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KKSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <1352303879.7614.2.camel@phoenix>
References: <1352303879.7614.2.camel@phoenix>
Date: Sun, 11 Nov 2012 19:20:27 +0100
Message-ID: <CACRpkdYAUVmw7hi1Pa96-AjsAFAxiWfmyqTLhceBjeeb8xduxQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: lantiq: Remove ltq_pmx_disable() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 4:57 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Current code adds empty ltq_pmx_disable() because pinmux_check_ops() requires
> this callback to be defined.
>
> This is not required since commit 02b50ce4cb1
> "pinctrl: make pinmux disable function optional".
>
> Thus remove ltq_pmx_disable() function.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with John's ACK.

Yours,
Linus Walleij
