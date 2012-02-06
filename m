Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2BFWEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:04:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14322 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2BFWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:04:04 -0500
Date: Mon, 6 Feb 2012 23:04:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: loading floppy driver corrupts memory.
In-Reply-To: <20120206213326.GA23938@redhat.com>
Message-ID: <alpine.LNX.2.00.1202062303050.20532@swampdragon.chaosbits.net>
References: <20120206213326.GA23938@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, Dave Jones wrote:

> I just saw the following corruption report with the Linus' tree as of
> 23783f817bceedd6d4e549385e3f400ea64059e5
> 
> modprobe/rmmod floppy is enough to trigger it..
> 

FYI:

I think this email thread may be relevant: 
https://lkml.org/lkml/2012/1/24/138


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

