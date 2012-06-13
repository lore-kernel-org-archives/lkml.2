Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2FMSAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:00:19 -0400
Received: from [213.133.104.84] ([213.133.104.84]:39436 "EHLO
	www84.your-server.de" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2FMSAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:00:17 -0400
Message-ID: <1339610440.18348.1.camel@wall-e>
Subject: Re: [PATCH 02/13] code cleanup
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, linux-usb@vger.kernel.org
Date: Wed, 13 Jun 2012 20:00:40 +0200
In-Reply-To: <20120613010209.GB6765@kroah.com>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
	 <1339057243-10029-3-git-send-email-stefani@seibold.net>
	 <20120613010209.GB6765@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 12.06.2012, 18:02 -0700 schrieb Greg KH:
> On Thu, Jun 07, 2012 at 10:20:32AM +0200, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > - consistent nameing
> > - more compact style
> > - remove unneeded code
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  drivers/usb/usb-skeleton.c |  119 +++++++++++++++++---------------------------
> >  1 files changed, 46 insertions(+), 73 deletions(-)
> 
> Your subject: needs to be fixed for all of these, as it does not
> describe what part of the kernel is being modified.
> 
> A better example would be to use a prefix of:
> 	Subject: [PATCH XX/13] USB: skeleton: 
> for all of these patches, so the shortlog entry is correct.
> 
> Care to redo this series, based on the feedback you've gotten, and
> resend?
> 

Yes, but i till take some time due my move to a new house.

Greetings,
Stefani


