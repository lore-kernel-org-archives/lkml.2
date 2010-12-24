Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0LXUlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:41:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21114 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0LXUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:41:09 -0500
Date: Fri, 24 Dec 2010 21:31:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: jgarzik@pobox.com
Subject: Re: [PATCH] gen_init_cpio: Avoid race between call to stat() and
 call to open()
In-Reply-To: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1012242130290.28973@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad subject.
Better subject: Avoid risk of file changing between calls to stat() and open().

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

