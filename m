Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0EUSxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:53:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab0EUSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:53:07 -0400
Date: Fri, 21 May 2010 11:50:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] Ext2, ext3, and quota updates for 2.6.35-rc1
In-Reply-To: <20100521184428.GC10149@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1005211146160.3689@i5.linux-foundation.org>
References: <20100521174658.GA10149@quack.suse.cz> <20100521184428.GC10149@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 May 2010, Jan Kara wrote:
>
>   Oops, I've just found a bug in one of my ocfs2 fixes. I've fixed that up
> so the new diffstat is here:

I already pulled your previous version.

And btw, Jan, I'm getting pretty upset with your apparently cavalier 
attitude to filesystems. We've had several bugs lately for some quota or 
filesystem "cleanups", which in at least one case caused corrupted 
filesystems etc.

You need to be a hell of a lot more careful, or I will have to stop 
pulling from you. Filesystem bugs are _major_ no-no's. 

How long had that buggy commit been tested? By who? Was it acked or 
reviewed by anybody else?

			Linus
