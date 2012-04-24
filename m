Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2DXOpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:45:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44116 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588Ab2DXOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:45:08 -0400
X-Sasl-enc: Nok01oiFju9fK2PciZ5rrnSLU8N5Y1mwGNxdVodqlctT 1335278706
Date: Tue, 24 Apr 2012 07:45:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the usb tree
Message-ID: <20120424144504.GB3532@kroah.com>
References: <20120424144820.326e86452826927b86aaf0f5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424144820.326e86452826927b86aaf0f5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 02:48:20PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/line6/driver.c between commit 2b8dec323d34 ("USB:
> driver.c: remove err() usage") from the usb tree and commit c46b8a6567fb
> ("Staging: line6: only allocate a buffer if it is needed") (and later)
> from the staging tree.
> 
> The latter supercedes the former, so I used that.

Thanks, that is correct.

greg k-h
