Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2DJIXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:23:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51723 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2DJIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <1333553270-9040-4-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
	<1333553270-9040-4-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:23:42 +0200
Message-ID: <CACRpkdZ2T2OUE2=NRXkzMNS61ojDYmaZv=H4AFm=1QPL_-JNyA@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 4/5] dt: Document Tegra20/30 pinctrl binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Define a new binding for the Tegra pin controller, which is capable of
> defining all aspects of desired pin multiplexing and pin configuration.
> This is all based on the new common pinctrl bindings.
>
> Add Tegra30 binding based on Tegra20 binding.
>
> Add some basic stuff that was missing before:
> * How many and what reg property entries must be provided.
> * An example.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> v3: Fix typo in Tegra20 binding example

Would be nice to have Grants or Robs ACK but tentatively
applied to the pinctrl tree anyway.

Yours,
Linus Walleij
