Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab1BQS5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:57:52 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:46628 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756931Ab1BQS5t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:57:49 -0500
Subject: Re: [PATCH v2 1/2] USB: ffs-test: fix header path
From: Davidlohr Bueso <dave@gnu.org>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <20110217184257.GA13545@kroah.com>
References: <1297012413.2039.8.camel@offworld>
	 <20110217184257.GA13545@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 15:57:32 -0300
Message-ID: <1297969052.21769.0.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 10:42 -0800, Greg KH wrote:
> On Sun, Feb 06, 2011 at 02:13:33PM -0300, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > When compiling this program the functionfs.h header cannot be found, producing:
> > ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> > 
> > This patch also fixes the following warning:
> > ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  tools/usb/ffs-test.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> This patch doesn't apply properly to the linux-next branch, what did you
> make it against?
> 

It was against Linus' tree (did a pull right before submitting the
patch).

> confused,
> 
> greg k-h
> 


