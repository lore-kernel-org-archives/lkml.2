Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2JKEhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:37:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49744 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JKEhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:37:42 -0400
Date: Thu, 11 Oct 2012 05:37:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/16] vfs: bogus warnings in fs/namei.c
Message-ID: <20121011043734.GE2616@ZenIV.linux.org.uk>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
 <20121008115116.GA9243@quack.suse.cz>
 <201210091227.46324.arnd@arndb.de>
 <201210091307.19225.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210091307.19225.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 01:07:19PM +0000, Arnd Bergmann wrote:

> Update: I could actually reproduce the problem now, but it only happens when
> building with 'gcc -s' (i.e. CONFIG_CC_OPTIMIZE_FOR_SIZE). It does happen
> with both gcc-4.6 and with gcc-4.8, and on both x86-64 and ARM. An alternative
> patch that would also make it go away is the variant below, but I think that's
> even worse than the first version I suggested because it makes the binary
> output slightly worse by adding an unnecessary initialization when building with
> 'make -s'.

I can live with that, provided that you give it sane commit message and
your s-o-b.
