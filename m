Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1CRKDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 06:03:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44853 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab1CRKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 06:03:41 -0400
Subject: Re: [PATCH 1/3] regulator: add set_voltage_time_sel infrastructure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
In-Reply-To: <1300364676-27563-1-git-send-email-linus.walleij@stericsson.com>
References: <1300364676-27563-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 10:03:36 +0000
Message-ID: <1300442616.3539.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 13:24 +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes it possible to set the stabilization time for voltage
> regulators in the same manner as enable_time(). The interface
> only supports regulators that implements fixed selectors.
> 
> Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

All look fine to me and have been applied.

Thanks

Liam

