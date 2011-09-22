Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1IVX2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:28:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55809 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab1IVX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:28:33 -0400
X-Sasl-enc: /EmQ1fWl73bXvBEwthuweVMjHUnA4Rzbb+gFp8Pg/+hB 1316734112
Date: Thu, 22 Sep 2011 16:28:28 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-console@vger.kernel.org
Subject: Re: [PATCH] drivers/tty: don't use the byte channel handle as a
 parameter in ehv_bytechan.c
Message-ID: <20110922232828.GA12088@kroah.com>
References: <1316543217-13769-1-git-send-email-timur@freescale.com>
 <20110922230640.GA16981@kroah.com>
 <4E7BC1A9.5050708@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7BC1A9.5050708@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 06:15:53PM -0500, Timur Tabi wrote:
> Greg KH wrote:
> > This patch doesn't apply at all to my tty tree, what was it made
> > against?
> 
> An internal repository that supposed to be in-sync with the latest and greatest.
> 
> What's the URL for your tty-next repo?

There is no public one due to kernel.org being down.

Does your patch apply to linux-next?
