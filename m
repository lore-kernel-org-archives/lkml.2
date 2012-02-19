Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2BSTuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:50:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2BSTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:50:16 -0500
Date: Sun, 19 Feb 2012 14:49:47 -0500 (EST)
Message-Id: <20120219.144947.660678318380307878.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: thomas@m3y3r.de, raven@themaw.net, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	<FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	<CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 11:49:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 10:45:26 -0800

> However, while true, x86-64 has 8-byte alignment for 'long', and
> x86-32 has 4-byte alignment. Which means that even though the
> structure layout is exactly the same, on x86-64 the *alignment* issue
> will push it out to 304 bytes.
> 
> That's just stupid. We've had that problem before. It's easy to
> overlook, but that packet is just mis-designed.

A real shame, this should have used "__aligned_u64" from the
beginning.
