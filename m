Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2A3SXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:23:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51691 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2A3SXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:23:40 -0500
Date: Mon, 30 Jan 2012 18:23:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] um: Use generic io.h
Message-ID: <20120130182333.GK23916@ZenIV.linux.org.uk>
References: <1327512234-22578-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327512234-22578-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 06:23:53PM +0100, Richard Weinberger wrote:
> There is no need to implement our own basic io functions.
> All we need exists already in asm-generic/io.h

Then just do

git rm arch/um/include/asm/io.h
echo 'generic-y += io.h' >>arch/um/include/asm/Kbuild
git add arch/um/include/asm/Kbuild

and be done with that.  We are already using generic-y for a bunch of
headers there...
