Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1FIRkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:40:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2684 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab1FIRkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:40:04 -0400
Subject: Re: [PATCH] Revised patch
From: Joe Perches <joe@perches.com>
To: Andrew Murray <amurray@mpcdata.com>
Cc: w.sang@pengutronix.de, geert@linux-m68k.org,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, rdunlap@xenotime.net, udknight@gmail.com,
        namhyung@gmail.com, Andrew Murray <amurray@mpc-data.co.uk>
In-Reply-To: <1307640826-22618-1-git-send-email-amurray@mpcdata.com>
References: <AANLkTikbPwMS0VGsMH64CGhDUEmvOwUzYnXSV0q3eW9_@mail.gmail.com>
	 <1307640826-22618-1-git-send-email-amurray@mpcdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 10:40:02 -0700
Message-ID: <1307641202.13329.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 18:33 +0100, Andrew Murray wrote:
> Hi,
> I've updated this patch based on your feedback. This covers all the recent feedback.

Hey Andrew.

You're missing the "%pB" backtrace extension.

It's be better if the "Hi, I've updated" comment stuff
came after the --- content separator in the patch so that
the commit log is a bit neater.

Otherwise, looks great, thanks.

cheers, Joe

