Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1BQTG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:06:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab1BQTGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:06:25 -0500
Date: Thu, 17 Feb 2011 11:05:54 -0800
From: Greg KH <gregkh@suse.de>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Greg KH <greg@kroah.com>, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] USB: ffs-test: fix header path
Message-ID: <20110217190554.GA25833@suse.de>
References: <1297012413.2039.8.camel@offworld>
 <20110217184257.GA13545@kroah.com>
 <1297969052.21769.0.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297969052.21769.0.camel@offworld>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:57:32PM -0300, Davidlohr Bueso wrote:
> On Thu, 2011-02-17 at 10:42 -0800, Greg KH wrote:
> > On Sun, Feb 06, 2011 at 02:13:33PM -0300, Davidlohr Bueso wrote:
> > > From: Davidlohr Bueso <dave@gnu.org>
> > > 
> > > When compiling this program the functionfs.h header cannot be found, producing:
> > > ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> > > 
> > > This patch also fixes the following warning:
> > > ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’
> > > 
> > > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > > ---
> > >  tools/usb/ffs-test.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > This patch doesn't apply properly to the linux-next branch, what did you
> > make it against?
> > 
> 
> It was against Linus' tree (did a pull right before submitting the
> patch).

Ah, so you think this is needed for Linus's tree now?  Care to resend it
and I'll queue it up to the proper tree, sorry, I missed that.

thanks,

greg k-h
