Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1FIRrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:47:40 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:46051 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1FIRrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jCbid/nXNxY6UNIJenXoUVnxkiwc/J1WCK0PokdANzOdtAM7QgdC48dulykZYcBJoz
         NjfIFIB3VIxbFkfZGwe9TbK/IodnvGGyum6JQ9CoCQqwrx5ktGmch2I8oZJY/HgFowgA
         cHreB5lbOTQ9bl8d9syHsNuEhn4eHMMZbtUyg=
Subject: Re: [PATCH] Revised patch
From: Namhyung Kim <namhyung@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Murray <amurray@mpcdata.com>, w.sang@pengutronix.de,
        geert@linux-m68k.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org, rdunlap@xenotime.net,
        udknight@gmail.com, Andrew Murray <amurray@mpc-data.co.uk>
In-Reply-To: <1307641202.13329.22.camel@Joe-Laptop>
References: <AANLkTikbPwMS0VGsMH64CGhDUEmvOwUzYnXSV0q3eW9_@mail.gmail.com>
	 <1307640826-22618-1-git-send-email-amurray@mpcdata.com>
	 <1307641202.13329.22.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 02:47:25 +0900
Message-ID: <1307641645.1326.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-06-09 (목), 10:40 -0700, Joe Perches:
> On Thu, 2011-06-09 at 18:33 +0100, Andrew Murray wrote:
> > Hi,
> > I've updated this patch based on your feedback. This covers all the recent feedback.
> 
> Hey Andrew.
> 
> You're missing the "%pB" backtrace extension.
> 

http://marc.info/?l=linux-kernel&m=130093458112438&w=2

Just for your information. :)
Thanks.


-- 
Regards,
Namhyung Kim


