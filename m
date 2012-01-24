Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2AXWog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:44:36 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16003 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2AXWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:44:34 -0500
Date: Tue, 24 Jan 2012 23:44:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 0/2] Staging: Style cleanup and mem leak fixes for
 drivers/staging/bcm/CmHost.c
Message-ID: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are two patches for drivers/staging/bcm/CmHost.c

I spotted some memory leaks and wanted to clean them up, but while doing 
so I thought "this function could do with a style cleanup" - then looked 
at another function and thought the same and then I looked at the entire 
file and thought "Ok, before I touch anything in here I'm going to clean 
it up to at least not hurt my eyes anymore".

So, the result is these two patches; the first does a basic style cleanup 
- far from perfect, but a huge improvement on what was there before, and 
the second fixes a few memory leaks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

