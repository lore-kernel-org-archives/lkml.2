Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0EYWdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:33:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab0EYWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:33:41 -0400
Date: Tue, 25 May 2010 15:32:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Julia Lawall <julia@diku.dk>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 12/27] drivers/ieee1394: Use memdup_user
Message-Id: <20100525153244.73069b6a.akpm@linux-foundation.org>
In-Reply-To: <4BF7A31B.2040302@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.1005221021460.13021@ask.diku.dk>
	<4BF7A31B.2040302@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 11:25:47 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Julia Lawall wrote:
> > Use memdup_user when user data is immediately copied into the
> > allocated region.
> 
> Looks nice.  We won't apply janitorial updates to drivers/ieee1394
> anymore though, since it is made obsolete by drivers/firewire and to be
> removed sooner than later.  (I will post a proposed removal schedule
> today to make this better known.)

I don't see much point in declaring a moratorium against
drivers/ieee1394.  Perhaps that removal will never happen.  Perhaps
third parties will find reason to revert that removal and to continue
to maintain drivers/ieee1394.  Perhaps people will take code snippets
from drivers/ieee1394 and will move them into drivers/firewire.

The bottom line is that the patch improves the code.  And there ain't
nothing wrong with having better code.

