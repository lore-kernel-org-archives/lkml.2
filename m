Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1CKM12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:27:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34830 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752674Ab1CKM10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:27:26 -0500
Date: Fri, 11 Mar 2011 12:27:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] regulator: initialization for ab8500 regulators
Message-ID: <20110311122724.GI1760@opensource.wolfsonmicro.com>
References: <1299840886-20679-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299840886-20679-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:54:46AM +0100, Linus Walleij wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> 
> The regulators on the AB8500 have a lot of custom
> hardware control settings pertaining to 8 external
> signals, settings which are board-specific and need
> be provided from the platform at startup.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
