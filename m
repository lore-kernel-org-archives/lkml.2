Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1ECRM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:12:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44551 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1ECRM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:12:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
Date: Tue, 3 May 2011 19:12:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201105030044.51661.rjw@sisk.pl> <201105031302.08910.rjw@sisk.pl> <20110503140608.GB7944@suse.de>
In-Reply-To: <20110503140608.GB7944@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031912.58736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 03, 2011, Greg KH wrote:
> On Tue, May 03, 2011 at 01:02:08PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Print a warning if firmware is requested when tasks are frozen
> > 
> > Some drivers erroneously use request_firmware() from their ->resume()
> > (or ->thaw(), or ->restore()) callbacks, which is not going to work
> > unless the firmware has been built in.  This causes system resume to
> > stall until the firmware-loading timeout expires, which makes users
> > think that the resume has failed and reboot their machines
> > unnecessarily.  For this reason, make _request_firmware() print a
> > warning and return immediately with error code if it has been called
> > when tasks are frozen and it's impossible to start any new usermode
> > helpers.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I'm guessing you will take this through your tree?

Yes, I will.

> If so, that's great:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks a lot!

Rafael
