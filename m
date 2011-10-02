Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1JBS7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:59:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38321 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1JBS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:59:13 -0400
Date: Sun, 2 Oct 2011 19:59:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Johannes Stezenbach <js@sig21.net>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: wm8782: Add __devexit_p at necessary place
Message-ID: <20111002185910.GJ2857@opensource.wolfsonmicro.com>
References: <1317516902.8024.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317516902.8024.0.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 08:55:02AM +0800, Axel Lin wrote:
> According to the comments in include/linux/init.h:
> 
> "Pointers to __devexit functions must use __devexit_p(function_name), the
> wrapper will insert either the function_name or NULL, depending on the config
> options."

Applied, thanks.
