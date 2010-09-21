Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0IUW0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:26:30 -0400
Received: from www.tglx.de ([62.245.132.106]:56418 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab0IUW03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:26:29 -0400
Date: Wed, 22 Sep 2010 00:26:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
In-Reply-To: <m1aana3fgc.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009220024470.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1eicw892p.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6> <20100921210809.GA28026@kroah.com> <alpine.LFD.2.00.1009212337030.2416@localhost6.localdomain6>
 <m1aana3fgc.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> The compiler will make this transformation on it's own when it compiles
> the code, because it does result in slightly better code.

I doubt the compiler part, but I'm not religious about that. It's a
question of personal preference.
 
> *shrug*  In the grand scheme of things it isn't a big deal.
> 
> I'm much more interested in getting the uio driver hotplug safe so when
> I physically remove a device I am using I don't get a kernel crash.

No objections.

   tglx
