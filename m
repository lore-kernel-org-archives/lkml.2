Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2JQRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:46:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35425 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab2JQRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350473820-25662-1-git-send-email-praithatha@nvidia.com>
References: <1350473820-25662-1-git-send-email-praithatha@nvidia.com>
Date: Wed, 17 Oct 2012 19:46:16 +0200
Message-ID: <CACRpkdZ07QrnFR4iBFWPAKtFkSwPqgWOb9f==b-EE_q5ayZ6cw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt: Document: correct tegra20/30 pinctrl slew-rate name
From: Linus Walleij <linus.walleij@linaro.org>
To: Pritesh Raithatha <praithatha@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        swarren@nvidia.com, dong.aisheng@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 1:37 PM, Pritesh Raithatha
<praithatha@nvidia.com> wrote:

> change nvidia,slew_rate* to nvidia,slew-rate*
>
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>

Applied w/Stephens ACK+test tag and @stable tag.

Yours,
Linus Walleij
