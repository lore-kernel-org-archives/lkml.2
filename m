Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1ANXnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:43:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42816 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1ANXnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:43:32 -0500
Date: Sat, 15 Jan 2011 00:43:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
Message-ID: <20110114234327.GS25713@one.firstfloor.org>
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com> <20110113235503.GY4739@erda.amd.com> <20110114002435.GR25713@one.firstfloor.org> <20110114022950.GC4739@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114022950.GC4739@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will it be the general way in the future not to add model detection
> for new Intel cpus to kernel code and instead use arch_perfmon? Are

Yes, at least for features that do not need specific new kernel support.
And it looks like most (all?) of the these features will be perf only.

The advantage of the scheme is that it avoids the major problems
we had with updates in the past where userland and kernel had to be
updated in lock-step.

> the user land patches for cpu detection already in the oprofile
> repository? I assume oprofile 0.9.6 is not up-to-date and needs to be
> patched.

It's in CVS.

-Andi
