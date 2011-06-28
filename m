Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab1F1Sa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:30:27 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54465 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760495Ab1F1S27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:28:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 28 Jun 2011 14:28:57 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Todd Poynor <toddpoynor@google.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Add generic idle notifiers
In-reply-to: <BANLkTi=1ZfWfDpUkSV0f1KoWmkJbxHg=_w@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1106281425340.2142@xanadu.home>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
 <BANLkTi=1ZfWfDpUkSV0f1KoWmkJbxHg=_w@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Bryan Wu wrote:

> On Tue, Jun 28, 2011 at 10:46 AM, Todd Poynor <toddpoynor@google.com> wrote:
> > Add notifiers for idle entry and exit, called with IDLE_START when a
> > CPU goes idle and IDLE_END when it goes out of idle, based on the
> > existing idle notifiers for the x86_64 arch.
> >
> > Convert x86_64 to use these notifiers, and call the notifiers on ARM.
> >
> > Convert the ARM LEDs events for idle start/end to these notifiers.
> >
> 
> LinusW and I is working on consolidation LED events interface in ARM.
> Please take a look at https://patchwork.kernel.org/patch/918792/

There is no conflict between those two series as one deals with the way 
the LED events are generated and the other with the way those events are 
acted upon.  The LED event mechanism in the middle is still untouched 
(could be deprecated eventually when all its users have migrated to the 
common LED API but not yet).


Nicolas
