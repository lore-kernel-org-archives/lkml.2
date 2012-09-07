Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab2IGOWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:22:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47958 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab2IGOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:22:27 -0400
Date: Fri, 7 Sep 2012 15:22:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Message-ID: <20120907142220.GL29601@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <201209071241.17198.arnd@arndb.de>
 <20120907130114.GF29601@gmail.com>
 <201209071358.38598.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209071358.38598.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:58:38PM +0000, Arnd Bergmann wrote:
> On Friday 07 September 2012, Lee Jones wrote:
> > Just running this by you, as there is method in the madness.
> > 
> > Linus wanted to keep changes to the Device Tree and changes
> > in platform code separate, which is my reason for submitting
> > all of my changes to date that way.
> > 
> > What I do (not sure if I've achieved that here yet, I'll need
> > to take another look) is; make changes to the driver which
> > enable it for Device Tree use. Then apply the DT node and remove 
> > platform registration in two subsequent patches respectively. 
> > Then when we come to bisect and land in between them we still
> > have a perfectly working driver, only the second probe fails 
> > which the only side-effect is some warnings in the boot log.
> 
> I'm sorry that you are getting conflicting directions from Linus
> and me. We can use the approach you suggest here this time,
> but I'd prefer if we can all agree on how to do this in the
> future.

I don't have an issue with that.

It would be good to have some guidelines to adhere to.

I'll double check that these ones are in the correct order, but
otherwise leave them as they are for this submission.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
