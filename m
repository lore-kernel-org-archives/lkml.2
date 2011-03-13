Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1CMN5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:57:21 -0400
Received: from www.tglx.de ([62.245.132.106]:38753 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab1CMN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:57:20 -0400
Date: Sun, 13 Mar 2011 14:56:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/8] timekeeping: Use syscore_ops instead of sysdev class
 and sysdev
In-Reply-To: <201103122217.34004.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1103131455320.2787@localhost6.localdomain6>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103122217.34004.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The timekeeping subsystem uses a sysdev class and a sysdev for
> executing timekeeping_suspend() after interrupts have been turned off
> on the boot CPU (during system suspend) and for executing
> timekeeping_resume() before turning on interrupts on the boot CPU
> (during system resume).  However, since both of these functions
> ignore their arguments, the entire mechanism may be replaced with a
> struct syscore_ops object which is simpler.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
