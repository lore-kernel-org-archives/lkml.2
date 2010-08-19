Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0HSOGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:06:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54677 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab0HSOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:06:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
Date: Thu, 19 Aug 2010 16:05:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Luis Rodriguez <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201008190001.11342.rjw@sisk.pl> <4C6CE715.4010203@kernel.org>
In-Reply-To: <4C6CE715.4010203@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191605.08053.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 19, 2010, Tejun Heo wrote:
> Hello, Rafael.
> 
> On 08/19/2010 12:01 AM, Rafael J. Wysocki wrote:
> > While testing 2.6.36-rc1 (with a couple of fixes on top) I noticed
> > that the ath9k driver didn't work after resume from suspend to RAM.
> > An attempt to unload the driver using rmmod caused the BUG_ON() in
> > kernel/workqueue.c:2844 to trigger.
> 
> That BUG_ON() triggers if destroy_workqueue() is called while work
> items are still pending on the workqueue.  Can you please trigger
> stack traces after resume and post it?

Do you mean sysrq-t?

Rafael
