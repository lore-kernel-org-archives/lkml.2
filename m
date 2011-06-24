Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1FXK5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:57:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28813 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1FXK5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:57:03 -0400
Date: Fri, 24 Jun 2011 12:48:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jiri Kosina <jkosina@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/37] Remove unneeded version.h includes (and add where
 needed).
In-Reply-To: <alpine.LNX.2.00.1106241112170.11049@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1106241247430.21168@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106241112170.11049@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011, Jiri Kosina wrote:

> On Thu, 23 Jun 2011, Jesper Juhl wrote:
> 
> > This patch series fixes up all reports of unneeded or missing 
> > linux/version.h includes reported by 'make versioncheck'.
> > 
> > I've manually inspected each file changed and also done build tests of 
> > 'allnoconfig', 'allmodconfig' and 'allyesconfig' on x86-64 with these 
> > patches and have encountered no problems.
> > 
> > All patches are against Linus' tree as of a few hours ago and I've tried 
> > to split the series sensibly by subdirectory and/or maintainer.
> > 
> > Please consider applying them and let me know if there are any issues that 
> > need to be worked out.
> > All patches will be submitted as replies to this mail with additional 
> > relevant people Cc'ed on each specific patch.
> 
> Hi Jesper,
> 
> I see that individual maintainers have started picking up the bits for 
> their subsystems.
> 
> Could you please give it a week or two and then check which ones are 
> missing in linux-next, and resend those to me?
> 
Sure thing.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

