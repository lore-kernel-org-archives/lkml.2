Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab1LJRTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 12:19:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53815 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab1LJRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 12:19:16 -0500
X-Sasl-enc: fIT4rc42bCdFMCX7NiJsouOh3c9VfczFHjPY/ApSGW83 1323537555
Date: Sat, 10 Dec 2011 09:16:44 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Drake <dsd@laptop.org>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, dilinger@queued.net,
        linux-kernel@vger.kernel.org, mjg@redhat.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] x86, olpc-xo15-sci: enable lid close wakeup control
 through sysfs
Message-ID: <20111210171644.GA16220@kroah.com>
References: <20111203171402.1D0F69D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111203171402.1D0F69D401E@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 05:14:01PM +0000, Daniel Drake wrote:
> Like most systems, OLPC's ACPI LID switch wakes up the system when the lid
> is opened, but not when it is closed.
> 
> Under OLPC's opportunistic suspend model, the lid may be closed while the
> system was oportunistically suspended with the screen running.  In this
> event, we want to wake up to turn the screen off.
> 
> Enable control of normal ACPI wakeups through lid close events through a
> new sysfs attribute "lid_wake_on_closed".  When set, and when LID wakeups
> are enabled through ACPI, the system will wake up on both open and close
> lid events.

As you are adding new sysfs files, you have to also include
Documentation/ABI entries for them as well.  Please do so in this patch.

thanks,

greg k-h
