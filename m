Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0COUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:36:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:39957 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0COUgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:36:13 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, drepper@redhat.com,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
In-Reply-To: <4B9E8D67.8040209@zytor.com>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 07:35:11 +1100
Message-ID: <1268685311.2335.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 12:41 -0700, H. Peter Anvin wrote:
> I don't see why syscall() can't change the type for its first argument
> -- it seems to be exactly what symbol versioning is for.
> 
> Doesn't change the fact that it is fundamentally broken, of course. 

No need to change the type of the first arg and go for symbol
versionning if you do something like I proposed earlier, there will be
no conflict between syscall() and __syscall() and both variants can
exist.

Cheers,
Ben.


