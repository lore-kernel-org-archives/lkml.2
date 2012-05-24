Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2EXPH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:07:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43545 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2EXPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205230019070.11851@axis700.grange>
References: <Pine.LNX.4.64.1205230019070.11851@axis700.grange>
Date: Thu, 24 May 2012 17:07:26 +0200
Message-ID: <CACRpkdYOjDoWKcn=XmNiSq3ptSFMXDWhL=jgbxih_gy1KgZd9Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix a minor harmless typo
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:20 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> The way the for_each_maps() macro is currently used, using "i" instead of
> "_i_" works and is harmless. Still, this is a bug, that can trigger any
> time, if the code around that macro changes. Better fix it now.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks! Applied with Stephen's ACK.

Yours,
Linus Walleij
