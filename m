Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2BJFeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:34:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38260 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534Ab2BJFeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:34:25 -0500
X-Sasl-enc: eGuWMykFmZ6OZumPT8nyyjFz4R3irVUZ/5K9kf/K3AQ8 1328852064
Date: Thu, 9 Feb 2012 21:30:13 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20120210053013.GB2068@kroah.com>
References: <20120210154753.54d5620ba268f2d1e8717838@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210154753.54d5620ba268f2d1e8717838@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 03:47:53PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/zcache/zcache-main.c between commit 2a4830110b90
> ("staging: zcache: fix serialization bug in zv stats") from Linus' tree
> (and also in the staging tree) and commit a49aeb1de585 ("staging: zcache:
> replace xvmalloc with zsmalloc") from the staging tree.
> 
> I used the staging tree version (since these were just further changes to
> the same bits of code).

Thanks, that sounds correct.

greg k-h
