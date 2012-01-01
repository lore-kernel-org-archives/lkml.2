Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2AANvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 08:51:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33138 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2AANvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 08:51:39 -0500
MIME-Version: 1.0
In-Reply-To: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
Date: Sun, 1 Jan 2012 14:51:39 +0100
Message-ID: <CACRpkdbcK9SGtQf9g55h_PGPenrvc9kxPYfZXNV1-4K8NvdAgg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 3:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> This patch implements a driver supporting Synaptics ClearPad and other
> touchscreen sensors that use the RMI4 protocol, as defined here:

This looks like a fundamental rewrite an huge improvement over the
previous RMI4 patches, good job!

I am not very deeply versed in the input subsystem but overall it looks
good to me, nice structure etc. I hope to be able to get back to a detailed
review and per-patch Acked-by:s ASAP.

Yours,
Linus Walleij
