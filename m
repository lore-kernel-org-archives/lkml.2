Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1K0Xov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 18:44:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab1K0Xot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 18:44:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] PM / Sleep: Unify diagnostic messages from device suspend/resume
Date: Mon, 28 Nov 2011 00:47:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201111272357.26930.rjw@sisk.pl> <201111272359.00539.rjw@sisk.pl> <20111127233016.GA30818@suse.de>
In-Reply-To: <20111127233016.GA30818@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111280047.42190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 28, 2011, Greg KH wrote:
> On Sun, Nov 27, 2011 at 11:59:00PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make pm_op() and pm_noirq_op() use the same helper function for
> > running callbacks, which will cause them to use the same format of
> > diagnostic messages.  This also reduces the complexity and size of
> > the code quite a bit.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Nice cleanup on both of these patches:
>  Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks!
