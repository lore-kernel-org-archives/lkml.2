Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0FDWfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:35:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab0FDWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:35:33 -0400
Date: Fri, 4 Jun 2010 15:30:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
In-Reply-To: <20100604204455.GD19761@kroah.com>
Message-ID: <alpine.LFD.2.00.1006041528291.8175@i5.linux-foundation.org>
References: <20100604204455.GD19761@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Greg KH wrote:
>
> Here are a number of bugfixes for the drivers/staging tree, as well as 3
> new stand-alone drivers.  The new drivers kind of obscure the diffstat
> showing the other fixes due to their size.

I pulled, but quite frankly, I don't want to see this kind of pull request 
again. There's just no _point_. 

I'll take new drivers outside the merge window, but there has to be some 
_reason_ for them. See the whole SCSI discussion a few merge windows ago. 
The new driver needs to improve the life of somebody to the point where I 
want to feel that there is a _reason_ for pulling it outside the merge 
window.

These drivers? Not so much. Not even f*cking close.

In other words: tell me why the new drivers couldn't just have waited for 
the next merge window? Really?

		Linus
