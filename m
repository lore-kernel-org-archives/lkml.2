Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1FMTOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:14:11 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:50204 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab1FMTOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:14:10 -0400
Date: Mon, 13 Jun 2011 21:14:07 +0200
From: Tobias Diedrich <ranma+kvm@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: QEMU Kernel panic - not syncing: IO-APIC +
 timer doesn't work!
Message-ID: <20110613191406.GA20616@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+kvm@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613173532.GG3502@yumi.tdiedrich.de>
 <20110613183825.GA31895@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613183825.GA31895@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 13, 2011 at 07:35:32PM +0200, Tobias Diedrich wrote:
> > Hi,
> > 
> > I ran into this problem when trying to set up Xen on a root server
> > with a pre-Orleans Athlon64 (no svm, so no kvm):
> 
> Uhh, your output says otherwise. What is the serial output your
> box produced?

Well, the output was from the kvm where I tried to boot xen with the
same config as on my rootserver, where I don't have access to the
console output to see why it doesn't boot. :)

> > So is this supposed to work with APICs?
> 
> Yes. Well, it actually should just bypass/ignore the APIC calls and
> the warnings are suppose to be benign.
> 
> But somehow your environment triggered a weird state. I've to admint
> I hadn't tried to boot Xen + paravirt Linux under QEMU for some time.
> 
> Did you try this on real hardware?

Only on my rootserver.  Just tried it again just in case and it
still doesn't boot if I remove the "noapic acpi=off" options.
(And it seems to blow up before I get any output over netconsole)

I should try it on my notebook I guess, though that is a Core2 Intel
with Vanderpool IIRC, so it may behave differently there.

> > APIC-support coming later?
> 
> Never. There should be no need for it.

Ok.

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
