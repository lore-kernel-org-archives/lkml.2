Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2JLVBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:01:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52856 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2JLVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121011065635.GD31607@elgon.mountain>
References: <20121011065635.GD31607@elgon.mountain>
Date: Fri, 12 Oct 2012 23:01:08 +0200
Message-ID: <CACRpkdZ0EfjMi8i9_bFYwscQVPCPGUFiJwv_FCTMfLbWwsUKZw@mail.gmail.com>
Subject: Re: [patch] gpio-timberdale: fix a potential wrapping issue
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 8:56 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> ->last_ier is an unsigned long but the high bits can't be used int the
> original code because the shift wraps.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!
Should we send this to stable? (I assume so ...)

Yours,
Linus Walleij
