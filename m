Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2FFVrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:47:13 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40325 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2FFVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE2EC5.2000403@wwwdotorg.org>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
	<4FBCF9F0.1010901@wwwdotorg.org>
	<Pine.LNX.4.64.1205231659310.21980@axis700.grange>
	<4FBD01A6.4080807@wwwdotorg.org>
	<CACRpkdbPe5jOmekPJBwryL5vkgUXsGyPijqDGqtYvK8AE6bCtw@mail.gmail.com>
	<4FCE2EC5.2000403@wwwdotorg.org>
Date: Wed, 6 Jun 2012 23:47:10 +0200
Message-ID: <CACRpkdbsUp+zPpvMAp1=CxMDn3dn2kP-m7t0QpNJnpnDYAqAow@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 6:07 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Well, you can't really have different "default" modes - "default" should
> be used when there truly is a single state that the device/driver just
> wants to get programmed. When the device/driver itself can support
> multiple different configurations, "default" isn't the right answer if
> the driver needs to derive information from the selected pinctrl state;
> there should be different pinctrl states for each possible configuration.

This is true...

> It's quite unlikely you'd ever want to switch between different states
> at runtime, or program the HW to be anything other than what the board
> supports, right?

I think so too, but I'm not sure if I once heard an argument to the
contrary. Anyway, let's assume so.

Yours,
Linus Walleij
