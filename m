Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2KDSWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:22:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49853 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2KDSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:22:29 -0500
MIME-Version: 1.0
In-Reply-To: <1351868545-15886-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1351868545-15886-1-git-send-email-alexander.stein@systec-electronic.com>
Date: Sun, 4 Nov 2012 19:22:28 +0100
Message-ID: <CACRpkdYjcvJ_F9drQGATtEjkfrkTvJ5VKr7SvdeKN5xwGzH-mg@mail.gmail.com>
Subject: Re: [PATCH] gpio-pch: Set parent dev for gpio chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 4:02 PM, Alexander Stein
<alexander.stein@systec-electronic.com> wrote:

> This will show the gpio chip as a child node
> under /sys/bus/pci/devices/xxxx:xx:xx.x/
>
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Thanks, patch applied!

Yours,
Linus Walleij
