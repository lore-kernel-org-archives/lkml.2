Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1EBTiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:38:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:54299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1EBTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:38:18 -0400
Subject: Re: linux-firmware tree
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Waychison <mikew@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com>
References: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 20:38:15 +0100
Message-ID: <1304365095.6400.20.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 19:57 +0100, Mike Waychison wrote:
> Hi David,
> 
> I'm trying to understand the purpose of the linux-firmware tree.
> Forgive me if this is a stupid question, but the only information
> about it I could find was your original post back in 2008:
> https://lwn.net/Articles/294308/
> 
> Will the Linux kernel sources always continue to have the firmware
> blobs and the linux-firmware tree is only for those users of distros
> that strip the firmware out?

No, the legacy firmware images from the kernel tree are going to be
removed. They were only kept for backward compatibility.

The linux-firmware tree has a lot of things that were never included in
the kernel source; no *new* firmware images are being (or at least
should be) added to the kernel source itself.

Everyone should be using the linux-firmware tree by now.

-- 
dwmw2

