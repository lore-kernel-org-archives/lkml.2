Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2ACTje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:39:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46503 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2ACTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:39:32 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1325616276-10304-1-git-send-email-sjg@chromium.org>
References: <1325616276-10304-1-git-send-email-sjg@chromium.org>
Date: Tue, 3 Jan 2012 11:39:31 -0800
Message-ID: <CAOesGMiN_yOxDT1Xrn3LOU+D027+oC3fxTPkph-WzpVPE-86Mg@mail.gmail.com>
Subject: Re: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
From: Olof Johansson <olof@lixom.net>
To: Simon Glass <sjg@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 10:44 AM, Simon Glass <sjg@chromium.org> wrote:
> BUILD_BUG_ON is defined in linux/kernel.h but that is not included by the
> asm/bug.h header which uses it. This causes a build error:
>
> ...include/linux/mtd/map.h: In function 'inline_map_read':
> ...include/linux/mtd/map.h:408:3: error: implicit declaration of function
> 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
>
> The check is not essential and is not present for other architectures, so
> just remove it.
>
> Signed-off-by: Simon Glass <sjg@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>

Simon, have you sent it to Russell's patch tracker? If not, please do.


-Olof
