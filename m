Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab1GKWhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:37:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1GKWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:37:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Bug #38522] address space collision error message on boot
Date: Tue, 12 Jul 2011 00:38:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jools Wills <jools@oxfordinspire.co.uk>, bhelgaas@google.com
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera> <XNkIyhV6dgF.A.D4G.TCYGOB@chimera> <CAA9_cmeY1Q-L_iMQfsf-KWufZzpkMSWzQ42ep=bQP9XZwyV-Lw@mail.gmail.com>
In-Reply-To: <CAA9_cmeY1Q-L_iMQfsf-KWufZzpkMSWzQ42ep=bQP9XZwyV-Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107120038.18847.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 11, 2011, Dan Williams wrote:
> [ adding Bjorn ]
> 
> On Sun, Jul 10, 2011 at 3:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> 
> The patch from the bugzilla entry is not yet upstream.
> 
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38522
> > Subject         : address space collision error message on boot
> > Submitter       : Jools Wills <jools@oxfordinspire.co.uk>
> > Date            : 2011-06-29 02:28 (12 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb
> 
> Per the commentary in the bugzilla this commit makes the warning
> message appear on 64-bit builds, but 32-bit has the same problem on
> affected platforms (without the commit).
> 
> Bjorn has a proposed patch [1] that just downgrades the warning since
> system operation does not appear to be affected.
> 
> --
> Dan
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=64102

Thanks for the update.

Rafael
