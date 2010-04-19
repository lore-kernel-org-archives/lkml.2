Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0DSTF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:05:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33551
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab0DSTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:05:56 -0400
Date: Mon, 19 Apr 2010 12:06:00 -0700 (PDT)
Message-Id: <20100419.120600.82034948.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, tilman@imap.cc, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
References: <20100419180520.GA9244@elte.hu>
	<alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
	<alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Apr 2010 12:00:49 -0700 (PDT)

> On Mon, 19 Apr 2010, Linus Torvalds wrote:
>> 
>> Maybe add the #include <linux/sched.h> into gigaset.h, instead of 
>> common.c?
> 
> This compiled for me, although the only thing I tried was just turning all 
> the gigaset options to 'y'. Maybe some other config doesn't work. So I 
> committed it as likely to fix things.

Thanks Linus.

Ingo, let us know if there is still some problems in your
build tests.
