Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1GaL0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 07:26:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55055 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1GaL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 07:26:08 -0400
Date: Sun, 31 Jul 2011 15:26:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110731112604.GH2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
 <20110731110641.GG2209@sun>
 <4E353A41.2010405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E353A41.2010405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 01:19:29PM +0200, Jiri Slaby wrote:
> On 07/31/2011 01:06 PM, Cyrill Gorcunov wrote:
> > On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> >> Hello,
> >>
> >> I'm seeing those kernel message when resuming:
> >>
> >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> >> [  524.973288] Do you have a strange power saving mode enabled?
> >> [  524.973289] Dazed and confused, but trying to continue
> >>
> >> I don't know if it's important or not because the system seems to work
> >> after but maybe it worths to report
> >>
> > 
> > Hi Francis, cpu please?
> 
> Hi, I'm seeing those too. For a longer time though. Please see
> https://bugzilla.novell.com/show_bug.cgi?id=678882#c16
> 
> I suspect NMI watchdog rewrite caused this.
> 

Crap. I thought we've resolved it (not exactly this one but still
unknown nmi issue) :) Still I don't remember if we paid much
attention on suspend/resume time. Don?

	Cyrill
