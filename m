Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0KCKX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:23:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39803 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0KCKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:23:53 -0400
Date: Wed, 3 Nov 2010 10:23:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bind-mount vs second mount of the same blockdev?
Message-ID: <20101103102352.GB19804@ZenIV.linux.org.uk>
References: <4CD12DED.3010902@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD12DED.3010902@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 12:39:57PM +0300, Michael Tokarev wrote:
>  mount -t ext3 /dev/block /mnt/a
>  mount --bind /mnt/a /mnt/b
> 
> versus
> 
>  mount -t ext3 /dev/block /mnt/a
>  mount -t ext3 /dev/block /mnt/b

[snip]

> What are the differences in behavour?

None.  Both lead to the identical states.
