Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1H3MFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:05:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52861 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3MFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:05:08 -0400
Date: Tue, 30 Aug 2011 13:04:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, jdike@addtoit.com
Subject: Re: [PATCH] um: fix strrchr problems
Message-ID: <20110830120459.GT2203@ZenIV.linux.org.uk>
References: <1314702244-3948-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314702244-3948-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 01:04:04PM +0200, Richard Weinberger wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> 
> [richard@nod.at:
> Fixes:
> /usr/lib/gcc/x86_64-linux-gnu/4.4.5/../../../../lib/libc.a(strrchr.o): In function `rindex':
> (.text+0x0): multiple definition of `strrchr'
> 
> If both STATIC_LINK and UML_NET_VDE are set to "y" libc's strstr
							    ^^^^^^
							    strrchr...
> may clash with the kernel implementation.
