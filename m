Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1AFPqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:46:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1AFPqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:46:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58 uploaded]
Date: Thu, 6 Jan 2011 16:45:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <201101060028.43342.rjw@sisk.pl> <4D258A55.2040003@gmail.com>
In-Reply-To: <4D258A55.2040003@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061645.28968.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 06, 2011, Jiri Slaby wrote:
> On 01/06/2011 12:28 AM, Rafael J. Wysocki wrote:
> > Two more questions:
> > (1) Does the failing machine power off correctly with the kernel that fails to
> >     suspend?
> 
> Poweroff is OK.
> 
> > (2) Is the failing suspend behavior reproducible if you run
> >     "echo disk > /sys/power/state" instead of "pm-suspend" in the platform test?
> 
> Thanks for the hint no_console_suspend with hibernate shows somwthing
> (opposing to suspend). I've sent a patch for the oops which occured due
> to ioremap change.

Can you send a link to the patch, please?

> The ioremap change still needs to be reverted, obviously.

Does it need to be reverted with your patch applied too?

Rafael
