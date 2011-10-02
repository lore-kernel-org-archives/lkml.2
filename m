Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1JBS7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:59:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38326 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1JBS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:59:20 -0400
Date: Sun, 2 Oct 2011 19:59:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: kirkwood-i2s: Add __devexit_p at necessary place
Message-ID: <20111002185918.GK2857@opensource.wolfsonmicro.com>
References: <1317518297.8024.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317518297.8024.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 09:18:17AM +0800, Axel Lin wrote:
> According to the comments in include/linux/init.h:

Applied, thanks.
