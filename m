Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1CDUxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:53:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab1CDUxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:53:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] ACPI / PM: Modify the "low-level resume finished" message
Date: Fri, 4 Mar 2011 21:53:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <201102072316.41270.rjw@sisk.pl> <201102072319.56040.rjw@sisk.pl> <20110304153807.GE1358@ucw.cz>
In-Reply-To: <20110304153807.GE1358@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042153.19301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Pavel Machek wrote:
> Hi!
> 
> > Move the low-level resume completion message to the point where
> > control goes back to acpi_suspend_enter() during resume and change
> > it so that it's more informative.
> 
> Well, doing some printk as soon as reasonably possible was helpful for
> debugging in the past. I'd move it sooner, not later.
> 
> (If you see that message, it means that normal printk debugging can be
> used, not exotic stuff like hashes in NVRAM).

That's what the patch is doing, isn't it?
