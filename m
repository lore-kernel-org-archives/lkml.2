Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2LSWNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:13:41 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38290 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2LSWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:13:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio-ich: Add missing spinlock init
To: Peter Tyser <ptyser@xes-inc.com>, Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1355932316.21821.31.camel@petert>
References: <20121216213140.22954434@endymion.delvare> <1355932316.21821.31.camel@petert>
Date: Wed, 19 Dec 2012 22:13:28 +0000
Message-Id: <20121219221328.4CD923E0AD6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 09:51:56 -0600, Peter Tyser <ptyser@xes-inc.com> wrote:
> On Sun, 2012-12-16 at 21:31 +0100, Jean Delvare wrote:
> > As reported by CONFIG_DEBUG_SPINLOCK=y.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Peter Tyser <ptyser@xes-inc.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: stable@vger.kernel.org [v3.5+]
> > ---
> 
> Acked-by: Peter Tyser <ptyser@xes-inc.com>
> 

Applied, thanks.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
