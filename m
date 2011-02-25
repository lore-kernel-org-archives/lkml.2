Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1BYWLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:11:45 -0500
Received: from www.tglx.de ([62.245.132.106]:36686 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1BYWLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:11:44 -0500
Date: Fri, 25 Feb 2011 23:11:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Performance/resume issues on Toshiba NB305
In-Reply-To: <20110225202748.GB24686@thinkpad-t410>
Message-ID: <alpine.LFD.2.00.1102252309480.2701@localhost6.localdomain6>
References: <20110225164239.GA24686@thinkpad-t410> <20110225201747.GB23161@home.goodmis.org> <20110225202748.GB24686@thinkpad-t410>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Seth Forshee wrote:
> On Fri, Feb 25, 2011 at 03:17:47PM -0500, Steven Rostedt wrote:
> > > One possible explanation here is that the performance problems are also
> > > related to hangs in SMI handlers until there's a timer interrupt,
> > > although I don't know how that explains why some of the command line
> > > options eliminate the performance issues.
> > 
> > Sounds like a buggy BIOS to me. Is there upgrades available for this
> > box?
> 
> It does sound like a buggy BIOS. I've already flashed the latest BIOS
> though, so no luck there.

Has the BIOS some knob to disable that feature^Wcrap? It's often
hidden behind some "$manufacturer super extra mode".

Thanks,

	tglx

