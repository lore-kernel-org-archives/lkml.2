Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab1E0DDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:03:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46150 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1E0DC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:02:59 -0400
Date: Thu, 26 May 2011 21:02:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] gpio: Convert gpio_is_valid to return bool
Message-ID: <20110527030256.GF5032@ponder.secretlab.ca>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
 <1304365077.7792.40.camel@Joe-Laptop>
 <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
 <1305067020.19586.130.camel@Joe-Laptop>
 <BANLkTi=zDJLHUa2ogTeEkmdsbkhvGJCsEw@mail.gmail.com>
 <1305069787.19586.141.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305069787.19586.141.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 04:23:07PM -0700, Joe Perches wrote:
> Make the code a bit more readable.
> 
> Instead of casting an int to an unsigned then comparing to
> MAX_NR_GPIOS, add a >= 0 test and let the compiler optimizer
> do the conversion to unsigned.
> 
> The generated code should be the same.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

g.

