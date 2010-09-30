Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0I3Pvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:51:39 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:53595 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0I3Pvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:51:37 -0400
X-Greylist: delayed 17618 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 11:51:37 EDT
X-Originating-IP: 217.70.178.41
X-Originating-IP: 80.4.117.127
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
From: Bastien Nocera <hadess@hadess.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201009300847.43090.dmitry.torokhov@gmail.com>
References: <1285844276.26405.26.camel@cookie.hadess.net>
	 <201009300847.43090.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 30 Sep 2010 16:51:30 +0100
Message-ID: <1285861890.26405.37.camel@cookie.hadess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.90 (2.31.90-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 08:47 -0700, Dmitry Torokhov wrote:
> Bastien,
> 
> On Thursday, September 30, 2010 03:57:55 am Bastien Nocera wrote:
> > This driver was originally written by James McKenzie, updated by
> > Greg Kroah-Hartman, further updated by myself, with suspend support
> > added.
> > 
> > More recent versions of the IR receiver are also supported through
> > a patch by Alex Karpenko. The patch also adds support for the 2nd
> > and 5th generation of the controller, and the menu key on newer
> > brushed metal remotes.
> > 
> > Tested on a MacbookAir1,1
> > 
> 
> There are no changes from the last time you sent it, right?

No, but given that I received no comments on it since I submitted it in
February, and again a couple of weeks ago, I thought it might need
somebody else to look into it.

>  I'll try
> to get the driver in .37 but after that we should probably move it
> over to the new IR infrastructure...

I'm not sure what that would bring us, nor do I have any experience in
using the ir-core. From what I understood, it still needed fleshing out.

Cheers

