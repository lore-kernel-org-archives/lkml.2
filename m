Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2DUVTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:19:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22704 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2DUVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:19:23 -0400
Date: Sat, 21 Apr 2012 23:19:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
cc: tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed atleast coding style issues relating spaces
In-Reply-To: <20120421211455.GA8179@debian.Jeff>
Message-ID: <alpine.LNX.2.00.1204212315150.25551@swampdragon.chaosbits.net>
References: <20120421211455.GA8179@debian.Jeff>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Jeffrin Jose wrote:

> hello 
> 
> I have fixed atleast coding style issues relating
> spaces in file sound/usb/card.c
> 
> Please see attachment.
> 

ok, So I took a quick look at the patch and I think it looks fine. So as 
far as that goes, feel free to add
  Acked-by: Jesper Juhl <jj@chaosbits.net>

but you really should try to send patches inline rather than as 
attachments. Attachments are a pain when you want to reply and quote and 
comment on the patch.

As far as the mail (patch) subject goes, I also feel a need to comment; 
what's up with "atleast"? Shouldn't it just be
"Fixed coding style issues relating to spaces" ??

Anyway, the actual change looks good to me.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

