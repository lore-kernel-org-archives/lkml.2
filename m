Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2CSV6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:58:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58120 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2CSV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:58:48 -0400
Message-ID: <1332194453.22775.91.camel@saladin.home.flameeyes.eu>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO,
 replacing gpio-it8761e.
From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 23:00:53 +0100
In-Reply-To: <20120319215324.A61BC3E0A04@localhost>
References: <1332174513-6657-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120319215324.A61BC3E0A04@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno lun, 19/03/2012 alle 21.53 +0000, Grant Likely ha scritto:
> 
> When you move and modify a driver all in one patch, then I don't have
> any way to review what has changed and therefore I cannot apply the
> patch.  At the very least the -M flag must be used with git diff so
> that it can detect the rename, but even better is to also split the
> move and the modification into separate patches. 

The problem is that it's not a move-and-modification: the new driver I
wrote from scratch, basing myself only on the code-flow from the it8761e
previously available (for the one I sent last week), then I re-added the
it8761e-specific features to that one when you asked me to see if I
could merge them back.

So for what it's worth, `git diff -M` won't show you any difference for
this as it won't recognize the new driver as a move-and-modification at
all... the only thing they have in common is the headers' inclusion..

-- 
Diego Elio Pettenò — Flameeyes
http://blog.flameeyes.eu/


