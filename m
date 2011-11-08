Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1KHBFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:05:21 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41806 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab1KHBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:05:19 -0500
X-Sasl-enc: iiMWq4mSHJEr0n8/GX47jq1XXd5JdyunJ864bSdxWwCg 1320714318
Date: Mon, 7 Nov 2011 17:04:06 -0800
From: Greg KH <greg@kroah.com>
To: Carla Sella <carla.sella@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: suspend/resume does not work on G62 notebook PC
Message-ID: <20111108010406.GC16800@kroah.com>
References: <4EB53C46.1060301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB53C46.1060301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 02:38:14PM +0100, Carla Sella wrote:
> Hello,
> I need to report a bug on  suspend/resume that's not working on my HP
> G62 notebook PC.
> I've been having this problem since testing Ubuntu Natty Beta 1 iso and
> I'm still having it with Ubuntu Oneiric.

What kernel version is that?

Can you try the 3.2-rc1 release?

thanks,

greg k-h
