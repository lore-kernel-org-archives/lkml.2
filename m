Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2FBL5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:57:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40360 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2FBL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:57:00 -0400
Date: Sat, 2 Jun 2012 04:56:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: morbid-rsa <morbidrsa@googlemail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stefanha@gmail.com, andor.daam@googlemail.com, grabner@icg.tugraz.at,
        jj@chaosbits.net, thomas@m3y3r.de
Subject: Re: [PATCH] drivers/staging/line6/variax.c: Change some
 strict_strtoul() calls
Message-ID: <20120602115655.GA12001@kroah.com>
References: <1337518508-23282-1-git-send-email-morbidrsa@googlemail.com>
 <CAGH8bx63_fBKnD3P6c3gn9odAjj4bXzVrpsOyE6grHT7hOYy-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGH8bx63_fBKnD3P6c3gn9odAjj4bXzVrpsOyE6grHT7hOYy-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 01:36:10PM +0200, morbid-rsa wrote:
> Just wanted to ask about the status of this patch.
> 
> On Sun, May 20, 2012 at 2:55 PM, Johannes Thumshirn
> <morbidrsa@googlemail.com> wrote:
> > Changed strict_strtoul() calls which do not result in a need to change
> > interfaces of called functions.
> >
> > Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> > ---
> >  drivers/staging/line6/variax.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)

As this came in after the merge window closed for patches, I have to
hold on to it until 3.5-rc1 comes out.  It's in my queue and not lost,
don't worry.

thanks for your patience,

greg k-h
