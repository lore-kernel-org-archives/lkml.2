Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1F0JoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:44:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49478 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab1F0Jlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:41:42 -0400
MIME-Version: 1.0
In-Reply-To: <1306757810-5291-1-git-send-email-linus.walleij@stericsson.com>
References: <1306757810-5291-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 27 Jun 2011 11:41:40 +0200
Message-ID: <BANLkTim0qum-ZbmaWaFwis7ONAhN+oGFAw@mail.gmail.com>
Subject: Re: [PATCH] staging: synaptics: Implement error handling for rmi4
 touch regulator
From: Linus Walleij <linus.walleij@linaro.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 2:16 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
>
> Implement the error handling for regulator in synaptics
> rmi4 touch screen
>
> Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> ---
> Somehow this patch has been lost and is pending in my local tree,
> so resending. The slowness of the "big" Synaptics driver to emerge
> gives me ideas about moving this to drivers/input :-P

Ping on this - can this go into staging now?

Thanks,
Linus Walleij
