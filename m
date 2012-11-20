Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2KTRNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:13:05 -0500
Received: from [93.179.225.50] ([93.179.225.50]:60904 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab2KTRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:13:03 -0500
Date: Tue, 20 Nov 2012 18:13:00 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty vt: Fix a regression in command line edition
Message-ID: <20121120171300.GA13195@shrek.podlesie.net>
References: <20121120173541.27e28d27@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121120173541.27e28d27@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 05:35:41PM +0100, Jean-Francois Moine wrote:
> From: Jean-François Moine <moinejf@free.fr>
> 
> The commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
> ("Fix line garbage in virtual console on command line edition")
> made a regression with some machines: some characters were not erased
> after line edition.
> 
> This patch adjusts the number of moved characters and the size of the
> region to be updated.
> 
> It may be applied on both kernels 3.6 and 3.7.
> 

3.6? Commit 81732c exists only in 3.7. 3.6 is not affected.

Krzysiek
