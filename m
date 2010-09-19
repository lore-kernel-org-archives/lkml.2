Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0ISPBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:01:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45974 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752218Ab0ISPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:01:50 -0400
Date: Sun, 19 Sep 2010 16:02:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] regulator: fix device_register() error handling
Message-ID: <20100919150209.GA18789@opensource.wolfsonmicro.com>
References: <1284900901-24537-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284900901-24537-1-git-send-email-segooon@gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 04:55:01PM +0400, Vasiliy Kulikov wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
