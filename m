Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2KKSWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:22:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39833 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KKSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:22:00 -0500
MIME-Version: 1.0
In-Reply-To: <1352304617.7614.7.camel@phoenix>
References: <1352303879.7614.2.camel@phoenix>
	<1352304617.7614.7.camel@phoenix>
Date: Sun, 11 Nov 2012 19:21:59 +0100
Message-ID: <CACRpkdZDNFA6=eLH95SpoDVyfjHa6bX8vz9rkC_xdpBvKS5UBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: lantiq: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 5:10 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Both ltq_pinctrl_dt_node_to_map() and ltq_pinctrl_dt_free_map() are not
> referenced outside of this file. Make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with John's ACK.

Yours,
Linus Walleij
