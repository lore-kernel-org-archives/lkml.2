Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0KEWMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:12:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37118
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880Ab0KEWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:12:12 -0400
Date: Fri, 05 Nov 2010 15:12:36 -0700 (PDT)
Message-Id: <20101105.151236.226781502.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: randy.dunlap@oracle.com, jaxboe@fusionio.com, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
	<20101103161638.ddc75ace.randy.dunlap@oracle.com>
	<AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 15:10:07 -0700

> Randy, is this one also related to that ipv6 percpu list corruption?
> IOW, does it go away with
> 
>   http://patchwork.ozlabs.org/patch/69939/
> 
> like one of your other reports did?
> 
> And David - I think we need that patch merged. The error case for when
> the percpu list entry is free'd without unlinking is _so_ annoying
> (random crashes in totally unrelated code) that I think we need to get
> that one closed asap. Hmm?

Agreed, I'll push this to you right now.
