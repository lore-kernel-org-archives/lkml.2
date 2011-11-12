Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1KLWKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:10:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1KLWKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:10:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] e978aa7d (cpuidle: Move dev->last_residency update...) broke suspend
Date: Sat, 12 Nov 2011 23:13:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
References: <874nyadwef.fsf@tac.ki.iif.hu> <201111120218.17758.rjw@sisk.pl> <87obwhcy1e.fsf@tac.ki.iif.hu>
In-Reply-To: <87obwhcy1e.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111122313.26968.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 12, 2011, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Saturday, November 12, 2011, Ferenc Wagner wrote:
> >> Hi,
> >> 
> >> Since e978aa7d (cpuidle: Move dev->last_residency update to driver
> >> enter routine; remove dev->last_state) my ThinkPad R50e can't suspend
> >> anymore, it just freezes instead.  I controlled git bisect by booting
> >> with break=top and issuing 'echo mem >/sys/power/state'.  My config is
> >> attached.
> >
> > What's the output of "cat /sys/devices/system/cpu/cpuidle/current_driver" ?
> 
> acpi_idle.
> 
> Your patch (ACPI / cpuidle: Remove acpi_idle_suspend) fixes the problem
> for me.  Amazing turnaround, really!

Well, I could reproduce the problem on one of my machines, so it wasn't
that difficult.

Thanks,
Rafael
