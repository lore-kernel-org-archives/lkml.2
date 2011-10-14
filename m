Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab1JNOlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:41:14 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60416 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246Ab1JNOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:41:12 -0400
X-Sasl-enc: 8X88KYHvuMn52KrjXZzheGUYpjFKq0BVnJht+pS+ig1v 1318603271
Date: Fri, 14 Oct 2011 08:33:29 -0600
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111014143329.GB9478@kroah.com>
References: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1110140956390.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110140956390.2036-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:05:41AM -0400, Alan Stern wrote:
> No, a much better approach is to remove all limits on individual
> transfer sizes and instead have a global limit on the total amount of
> all usbfs buffers in use at any time.  Maybe something like 16 MB; at 
> SuperSpeed, that's about about 30 ms worth of data.

That sounds quite reasonable.

greg k-h
