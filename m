Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab2ECVtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:49:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50327 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455Ab2ECVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:49:46 -0400
X-Sasl-enc: 3KVt3VTcSkjMQV9NT089EZEOHrtt1q6uwL9hmVT2Z6ia 1336081784
Date: Thu, 3 May 2012 14:49:43 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: linux-next: manual merge of the usb tree with the input tree
Message-ID: <20120503214943.GB16912@kroah.com>
References: <20120503144421.bce525fdec4a9b2d3b7557d5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503144421.bce525fdec4a9b2d3b7557d5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:44:21PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/input/tablet/wacom_wac.c between commit eb71d1bb270e ("Input:
> wacom - use dev_xxx() instead of naked printk()s and dbg()s") from the
> input tree and commit 3b6aee237e88 ("USB: wacom: remove dbg() usage")
> from the usb tree.
> 
> I just used the input tree's version (which used "input->dev.parent"
> instead of "&input->dev").

That's fine, Dmitry and I are still "discussing" which pointer is best
to use on lkml, but either is good for the merge :)

thanks,

greg k-h
