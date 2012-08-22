Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab2HVSjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:39:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38135 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab2HVSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <1345643359-16584-3-git-send-email-stigge@antcom.de>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
	<1345643359-16584-3-git-send-email-stigge@antcom.de>
Date: Wed, 22 Aug 2012 20:39:06 +0200
Message-ID: <CACRpkdaYqNYCy5=mS=VvsD1zJU+NnZ5BU1-kjDLAnYsRSZvFGg@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] DT bindings documentation: "num-cs" property for
 SPI controllers
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: aletes.xgr@gmail.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 3:49 PM, Roland Stigge <stigge@antcom.de> wrote:

> Several SPI controller drivers have defined differently named properties for
> the number of chip selects.  Now adding "num-cs" as a reference name for new
> bindings.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
