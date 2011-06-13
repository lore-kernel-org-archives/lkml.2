Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1FMQNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:13:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62576 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1FMQNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110613150856.GD18161@ponder.secretlab.ca>
References: <1307962426-19230-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
	<20110613150856.GD18161@ponder.secretlab.ca>
Date: Mon, 13 Jun 2011 18:13:02 +0200
Message-ID: <BANLkTi=A+Sn7Fx_ta92EGRaz6MLbiAdsdA@mail.gmail.com>
Subject: Re: [PATCH] spi-pl022: Add missing return value update
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 5:08 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jun 13, 2011 at 04:23:46PM +0530, Virupax Sadashivpetimath wrote:
>> Return error on out of range cpsdvsr value.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
>
> It looks like this is a bug fix for v3.0, and probably for -stable too, correct?

ACK

Linus Walleij
