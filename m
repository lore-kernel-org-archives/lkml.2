Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1EYIvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:51:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12451 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1EYIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:51:45 -0400
Date: Wed, 25 May 2011 10:44:08 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Bob Liu <lliubbo@gmail.com>
cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfs: where is get_sb_single()?
In-Reply-To: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105251043220.12052@swampdragon.chaosbits.net>
References: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Bob Liu wrote:

> Hi, folks
> 
> I found that fs/super.c doesn't have get_sb_single() anymore.
> 
> But I can't find the git log which delete that function.
> Some out of tree file systems depends on that function.
> 

commit 1a102ff92579edeff5e3d5d3c76ca49977898f00 by Al Viro removed that.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

