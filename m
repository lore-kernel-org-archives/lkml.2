Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1JQSRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1JQSRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:17:01 -0400
Date: Mon, 17 Oct 2011 20:16:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
In-Reply-To: <20111017175906.GA3461@schottelius.org>
Message-ID: <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
References: <20111017175906.GA3461@schottelius.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Nico Schottelius wrote:

> Hello LKML,
> 
> after several days of reading various forums and mailinglists,
> it seems that keyboard and mouse support on the MacBook Air is
> pretty broken:
> 
> - The fn key does not modify the cursor behaviour:
>   FN+Cursor up should result in Page up,
>   FN+Cursor down should result in Page down, etc.
> 
>   Actual result: Cursor keys are passed in as usual
> 
> - The multitouch trackpad only works if bcm5974 is loaded before usbhid
>   -> otherwise only left click works
> 
> - If bcm5974 is loaded before usbhid, left moving the mouse while
>   holding down the mouse button (i.e. the trackpad) does not work,
>   but results in a right click
> 
> Anyone a pointer on how to fix these issues?

Please try with my hid.git tree, preferably for-next branch. Namely 
commit 4b086910ad1.

Thanks,

-- 
Jiri Kosina
SUSE Labs

