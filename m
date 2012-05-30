Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2E3XMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:12:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2E3XMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:12:13 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1337423333-24356-1-git-send-email-stigge@antcom.de>
References: <1337423333-24356-1-git-send-email-stigge@antcom.de>
Date: Wed, 30 May 2012 16:12:13 -0700
Message-ID: <CAOesGMiUccXi6JVu2zqYizgV_076Ek-A+KyrfLGFfw8xELaSdQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: LPC32xx: Adjust dts files to gpio dt binding
From: Olof Johansson <olof@lixom.net>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 3:28 AM, Roland Stigge <stigge@antcom.de> wrote:
> The GPIO devicetree binding in 3.5 doesn't register the various LPC32xx GPIO
> banks via DT subnodes but always all at once, and changes the gpio referencing
> to 3 cells (bank, gpio, flags). This patch adjusts the DTS files to this
> binding that was just accepted to the gpio subsystem.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Thanks, applied to fixes for 3.5.


-Olof
