Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1K1LzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:55:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1K1LzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:55:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] PM / Sleep: Drop pm_op() and pm_noirq_op()
Date: Mon, 28 Nov 2011 12:58:12 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201111272357.26930.rjw@sisk.pl> <201111272359.36511.rjw@sisk.pl> <20111127233029.GB30818@suse.de>
In-Reply-To: <20111127233029.GB30818@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281258.12389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 28, 2011, Greg KH wrote:
> On Sun, Nov 27, 2011 at 11:59:36PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The helper functions pm_op() and pm_noirq_op() are not really
> > necessary and they don't do anything useful, so drop them.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Unfortunately, this one isn't correct, because it would make the PM core
silently ignore the freeze/thaw and poweroff/restore callbacks, so I'm
withdrawing it.

Patch [1/2] is still OK, though.

Thanks,
Rafael
