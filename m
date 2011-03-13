Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1CMPIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:08:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab1CMPH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:07:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/8] timekeeping: Use syscore_ops instead of sysdev class and sysdev
Date: Sun, 13 Mar 2011 16:08:14 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122217.34004.rjw@sisk.pl> <alpine.LFD.2.00.1103131455320.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103131455320.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131608.14914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Thomas Gleixner wrote:
> On Sat, 12 Mar 2011, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The timekeeping subsystem uses a sysdev class and a sysdev for
> > executing timekeeping_suspend() after interrupts have been turned off
> > on the boot CPU (during system suspend) and for executing
> > timekeeping_resume() before turning on interrupts on the boot CPU
> > (during system resume).  However, since both of these functions
> > ignore their arguments, the entire mechanism may be replaced with a
> > struct syscore_ops object which is simpler.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

Rafael
