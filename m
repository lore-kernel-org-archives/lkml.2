Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0IXExD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:53:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58342
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab0IXExB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:53:01 -0400
Date: Thu, 23 Sep 2010 21:53:21 -0700 (PDT)
Message-Id: <20100923.215321.90804782.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100923002757.GI19804@ZenIV.linux.org.uk>
References: <20100922204323.GG19804@ZenIV.linux.org.uk>
	<20100922.141514.232744402.davem@davemloft.net>
	<20100923002757.GI19804@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 23 Sep 2010 01:27:57 +0100

> Dave, are you OK with the following patch?  That should cover both sparc32
> and sparc64...
> 
> Subject: [PATCH] sparc: keep calling do_signal() as long as pending signals remain

Looks great, I'll apply this and give it some of my own testing.

I'll also take care of that unaligned stack pointer issue on sparc32.

Thanks!
