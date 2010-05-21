Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0EUQWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:22:47 -0400
Received: from sous-sol.org ([216.99.217.87]:45154 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755873Ab0EUQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:22:46 -0400
Date: Fri, 21 May 2010 09:22:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jiri Kosina <jikos@jikos.cz>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: linux-next: build warnings after merge of the driver-core tree
Message-ID: <20100521162221.GU8301@sequoia.sous-sol.org>
References: <20100521161843.20e795db.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521161843.20e795db.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell (sfr@canb.auug.org.au) wrote:
...
> drivers/hid/hid-roccat-kone.c:731: warning: initialization from incompatible pointer type
> 
> Introduced by commit 867040163f10f2b52b45bc573f330d6eb28f5914 ("sysfs:
> add struct file* to bin_attr callbacks") from the driver-core tree
> interacting with commit 14bf62cde79423a02a590e02664ed29a36facec1 ("HID:
> add driver for Roccat Kone gaming mouse") from the hid tree.
> 
> I added the following patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 21 May 2010 16:15:32 +1000
> Subject: [PATCH] hid: fix hid-roccat-kone for bin_attr API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Yep, looks good.  I figured we'd hit one or two of those w/ the API
change.

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris
