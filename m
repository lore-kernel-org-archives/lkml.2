Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0L1Bka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 20:40:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53274 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0L1Bk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 20:40:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XMzcSXYEdLeJEIWkv8fdCx2GuFeB4tExoelPn4nWTlTVkFVUPjybCKVXbNidJsODqy
         uqDPlofyqfFNbyHk/L37fsovizkz4a1B4wW6U68FTL9pVLVNPl413JVGszQ210ry+tYD
         0m5/3NiJF3uZZESQpOe30bBYsYLzb4RQbmdDA=
Date: Mon, 27 Dec 2010 17:40:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: David Sterba <dsterba@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH] Input: bu21013_ts: fix misuse of logical operation in
 place of bitop
Message-ID: <20101228014020.GA25077@core.coreip.homeip.net>
References: <1293464210-21649-1-git-send-email-dsterba@suse.cz>
 <AANLkTimaPn51QZNRFr-L5KgOQTWJf=RzoDSxegAiO_4O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimaPn51QZNRFr-L5KgOQTWJf=RzoDSxegAiO_4O@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 01:38:43AM +0100, Linus Walleij wrote:
> 010/12/27 David Sterba <dsterba@suse.cz>:
> 
> > CC: Linus Walleij <linus.walleij@stericsson.com>
> > CC: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > CC: Henrik Rydberg <rydberg@euromail.se>
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> 

Applied, thank you.

-- 
Dmitry
