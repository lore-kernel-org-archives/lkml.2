Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1FBH6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:58:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:51756 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab1FBH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:58:45 -0400
Subject: Re: [BUG] OHCI crash when handover fails
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110530162528.GB2386@linutronix.de>
References: <1306454011.7481.529.camel@pasglop>
	 <1306458168.7481.531.camel@pasglop>  <20110530162528.GB2386@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 17:58:26 +1000
Message-ID: <1307001506.29297.61.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 18:25 +0200, Sebastian Andrzej Siewior wrote:
> * Benjamin Herrenschmidt | 2011-05-27 11:02:48 [+1000]:
> 
> >BTW. The same handover failure didn't cause a crash yesterday, so this
> >is a regression that happened with whatever Linus pulled last night, I
> >probably won't have a chance to bisect it tho for various reasons.
> 
> Ben, this is probably fixed by
>  http://marc.info/?l=linux-fsdevel&m=130676974227377&w=2

Sorry for the delay testing, got bogged down by more 3.0-*
regressions :-(

The patch does indeed fix the problem for me. I noticed that it's still
not upstream tho :-) Can you send it to Linus asap ?

Cheers,
Ben.


