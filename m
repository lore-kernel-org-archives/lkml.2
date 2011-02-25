Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab1BYWeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:34:03 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51335 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:34:01 -0500
Date: Fri, 25 Feb 2011 16:33:57 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110225223357.GE24686@thinkpad-t410>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20110225164239.GA24686@thinkpad-t410>
 <20110225201747.GB23161@home.goodmis.org>
 <20110225202748.GB24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252309480.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102252309480.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:11:31PM +0100, Thomas Gleixner wrote:
> On Fri, 25 Feb 2011, Seth Forshee wrote:
> > On Fri, Feb 25, 2011 at 03:17:47PM -0500, Steven Rostedt wrote:
> > > > One possible explanation here is that the performance problems are also
> > > > related to hangs in SMI handlers until there's a timer interrupt,
> > > > although I don't know how that explains why some of the command line
> > > > options eliminate the performance issues.
> > > 
> > > Sounds like a buggy BIOS to me. Is there upgrades available for this
> > > box?
> > 
> > It does sound like a buggy BIOS. I've already flashed the latest BIOS
> > though, so no luck there.
> 
> Has the BIOS some knob to disable that feature^Wcrap? It's often
> hidden behind some "$manufacturer super extra mode".

You mean the "hang in SMI until a timer interrupt fires" feature? ;)

There's nothing in the BIOS settings that looks relevant to either of
the topics at hand.

