Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2FXXzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:55:41 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12008 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2FXXzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:55:40 -0400
Date: Mon, 25 Jun 2012 01:55:39 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/14][v2] staging: vt6656: Style cleanup of iwctl
Message-ID: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a second attempt at a style cleanup of 
drivers/staging/vt6656/iwctl.[ch].
This time broken into a series of patches rather than the monster 3000+ 
line patch that I previously submitted (thanks Dan for setting me 
straight). Hopefullt this will be more reviewable :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

