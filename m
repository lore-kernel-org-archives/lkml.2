Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2DJIUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:20:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39056 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2DJIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1333553270-9040-3-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
	<1333553270-9040-3-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:20:39 +0200
Message-ID: <CACRpkdbcEAyZ=hkT3jQ_oqGuokBrUjGHWAGem_kj8DkJrWhQVQ@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 3/5] dt: Move Tegra20 pin mux binding into new
 pinctrl directory
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
> This places the file in the new location for all pin controller bindings.
>
> Also, rename the file using the full compatible value for easier
> avoidance of conflicts between multiple bindings.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Would be nice to have ACKs from Grant or Rob on this but
tentatively applied to the pinctrl tree anyway.

Yours,
Linus Walleij
