Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0JMSdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:33:03 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:62208 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0JMSdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:33:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19637.64348.72182.502916@pilspetsen.it.uu.se>
Date: Wed, 13 Oct 2010 20:33:00 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc regression] occasional complete system hangs on
 sparc64 SMP
In-Reply-To: <20101012.144039.245407019.davem@davemloft.net>
References: <19611.34846.813757.309183@pilspetsen.it.uu.se>
	<19624.63312.156073.410319@pilspetsen.it.uu.se>
	<20101012.144039.245407019.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > 
 > BTW, and this is a long shot, but in another thread someone
 > reported that the following patch causes sporadic problems
 > for them.
 > 
 > Can you try reverting it from the current tree and seeing if
 > that makes the hangs go away?
 > 
 > Thanks!
 > 
 > commit 6dda9d55bf545013597724bf0cd79d01bd2bd944
 > Author: Corrado Zoccolo <czoccolo@gmail.com>
 > Date:   Mon May 24 14:31:54 2010 -0700
 > 
 >     page allocator: reduce fragmentation in buddy allocator by adding buddies that are merging to the tail of the free lists

I'll test -rc7 with this one reverted tomorrow.
