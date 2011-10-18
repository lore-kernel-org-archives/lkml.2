Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1JROPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:15:07 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32996 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265Ab1JROPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:15:04 -0400
X-Sasl-enc: k3SLzh/hPG/sRCEaV/TMYk8s1SgCGXZzLduoJir6AhYs 1318947304
Date: Tue, 18 Oct 2011 07:13:50 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josh Boyer <jwboyer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Update email address for stable patch submission
Message-ID: <20111018141350.GB17101@kroah.com>
References: <20111018011638.GQ1165@zod.bos.redhat.com>
 <20111018065852.GA6056@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018065852.GA6056@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 02:58:52AM -0400, Christoph Hellwig wrote:
> On Mon, Oct 17, 2011 at 09:16:39PM -0400, Josh Boyer wrote:
> > The stable@kernel.org email address has been replaced with the
> > stable@vger.kernel.org mailing list.  Change the stable kernel rules to
> > reference the new list instead of the semi-defunct email alias.
> 
> Does this mean it already stopped working?  I recently sent pathces
> there but neither got an ACK nor a bounce or similar.

It should have bounced.

But, if you put a "Cc: stable@kernel.org" in the patch, I'm still
picking that up properly when it goes to Linus's tree.

If I haven't responded to any patches you have sent to stable@ already,
please resend them to stable@vger.kernel.org and cc: me to ensure it
gets here.

thanks,

greg k-h
