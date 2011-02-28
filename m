Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1B1QEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:04:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:41883 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1B1QEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:04:15 -0500
Date: Mon, 28 Feb 2011 08:04:59 -0800
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel@pengutronix.de, Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] tty/vt: add some KERN_CONT markers to continuation
 lines
Message-ID: <20110228160459.GB27184@suse.de>
References: <20101124085645.GW4693@pengutronix.de>
 <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110228151641.GN22310@pengutronix.de>
 <20110228153946.GA26719@suse.de>
 <20110228155008.GQ22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110228155008.GQ22310@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:50:08PM +0100, Uwe Kleine-König wrote:
> Hello Greg,
> 
> On Mon, Feb 28, 2011 at 07:39:46AM -0800, Greg KH wrote:
> > On Mon, Feb 28, 2011 at 04:16:41PM +0100, Uwe Kleine-König wrote:
> > > Hello Greg,
> > > 
> > > should this patch go via your tree?
> > 
> > Yes, care to resend it in a format I can apply it in?
> I bounced you the original mail assuming this is enough.

Yup, I'll queue it up in a few days, thanks.

greg k-h
