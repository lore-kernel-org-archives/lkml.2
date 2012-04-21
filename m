Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DUScj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:32:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17410 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2DUSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:32:38 -0400
Date: Sat, 21 Apr 2012 20:32:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Woodhouse <dwmw2@infradead.org>,
        Andres Salomon <dilinger@queued.net>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 0/3] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Greg KH asked that these changes, which I had originally put in a single 
patch, be submitted as individual patches with just a single change per 
patch. So here goes.

The 3 patches - submitted as replies to this email are:


1)
Subject: [PATCH 1/3] staging: olpc_dcon.c: strings printed with printk() put on a single line

Quoted strings that were broken over multiple lines are put on a
single line for easier grep'ability.


2)
Subject: [PATCH 2/3] staging: olpc_dcon.c: Add missing level to a printk()


3)
Subject: [PATCH 3/3] staging: olpc_dcon.c: Remove a few spaces between casts and variables

Just a trivial style cleanup.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

