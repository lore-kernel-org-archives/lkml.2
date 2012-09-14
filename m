Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2INKER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:04:17 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57543 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab2INKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:04:15 -0400
Date: Fri, 14 Sep 2012 12:04:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4]: ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120914100413.GB3990@breakpoint.cc>
References: <20120914050328.GB21944@kroah.com>
 <6bca77b6-f91c-4ec2-acb2-91b892303502@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bca77b6-f91c-4ec2-acb2-91b892303502@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 08:52:58AM +0200, Rene Buergel wrote:
> > Git should show this as a move, not as a "add a file and remove a
> > file"
> > type patch.  Are you generating it properly?
> 
> Whats the proper way to do this? I did a git mv, git commit and than git diff on that commit hash.

Thatis okay but while you create the patch you should use the -M switch in
`git format-patch` command. You could also try to use `git send-email` which
should create proper threads and avoid copy/paste formating problems (in case
there were any).

Sebastian
