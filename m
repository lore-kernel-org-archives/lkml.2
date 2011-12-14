Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1LNOre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:47:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38532 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1LNOrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:47:33 -0500
Date: Wed, 14 Dec 2011 15:47:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Message-ID: <20111214144722.GA10791@somewhere.redhat.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
 <20111213192556.GD2421@somewhere.redhat.com>
 <20111214081809.GJ25232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214081809.GJ25232@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:18:09AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Dec 12, 2011 at 04:52:18PM -0500, Seiji Aguchi wrote:
> > > Hi,
> > > 
> > > I'm interested in these tracepoints.
> > > But this patch removed from -mm tree for some reason.
> > > 
> > > http://www.spinics.net/lists/mm-commits/msg85707.html
> > > 
> > > Do you plan to update it and push to upstream?
> > 
> > Oh weird. Doesn't seem to be in -tip either. Anybody has
> > any clue about where this patch went?
> 
> Didn't Thomas critique them - if so then were those observations 
> addressed?
> 
> Thanks,
> 
> 	Ingo


Ah right. Vaibhav any news about that?
