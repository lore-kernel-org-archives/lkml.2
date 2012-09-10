Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2IJHJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:09:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49880 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IJHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <1346835718-21325-2-git-send-email-peter.ujfalusi@ti.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
	<1346835718-21325-2-git-send-email-peter.ujfalusi@ti.com>
Date: Mon, 10 Sep 2012 09:09:28 +0200
Message-ID: <CACRpkdZW=HSEMT123y6gUO=Dh_7aZnfVn_2bKWCRuaSC6xjHnQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-single: Make sure we do not change
 bits outside of mask
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Applied with Tony's ACK.

Yours,
Linus Walleij
