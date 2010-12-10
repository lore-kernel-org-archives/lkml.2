Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0LJMZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:25:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35945 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755764Ab0LJMZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:25:02 -0500
Date: Fri, 10 Dec 2010 12:25:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/9] regulators: Fixed errors in ab8500 register mapping
Message-ID: <20101210122512.GB2518@opensource.wolfsonmicro.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1291975728-12525-3-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291975728-12525-3-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 11:08:41AM +0100, Bengt Jonsson wrote:
> For INTCORE and TVOUT regulators, the low power register bit is
> included in the mask so that enable will set the regulator in
> normal (high power) mode.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
