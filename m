Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2HLUy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 16:54:58 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2HLUy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 16:54:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [Regression, post-3.5] NULL pointer dereference in usb-wwan after resume from system suspend
Date: Sun, 12 Aug 2012 23:00:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <201208120039.19463.rjw@sisk.pl> <20120811225609.GA20031@kroah.com>
In-Reply-To: <20120811225609.GA20031@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208122300.49084.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 12, 2012, Greg Kroah-Hartman wrote:
> On Sun, Aug 12, 2012 at 12:39:19AM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The usb-wwan driver triggers a NULL pointer dereference oops after resume
> > from system suspend on my Toshiba Portege R500, but since that driver
> > hasn't changed since v3.5 and it is only used by the option driver, I suppose
> > that the latter is responsible for that.
> > 
> > This is a clear regression from v3.5, it hasn't happened ever before.
> > 
> > I'll collect some details tomorrow.
> 
> Known bug, we have a fix for it in the usb-next tree now, it will be
> going to Linus in a few days.

Cool. :-)

> If you want, I can dig up the patch for it and send it to you, if it's
> stopping other things from working for you at the moment.

No, it's not delaying me, thanks!

Rafael
