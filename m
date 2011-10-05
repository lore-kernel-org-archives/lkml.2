Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490Ab1JEWlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:41:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935461Ab1JEWlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:41:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task freezing failures
Date: Thu, 6 Oct 2011 00:43:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Tejun Heo <tj@kernel.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20111002195023.GC31799@mtj.dyndns.org> <201110052226.58373.rjw@sisk.pl> <4E8CC8FA.2090100@linux.vnet.ibm.com>
In-Reply-To: <4E8CC8FA.2090100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110060043.19583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 05, 2011, Srivatsa S. Bhat wrote:
> On 10/06/2011 01:56 AM, Rafael J. Wysocki wrote:
> > 
> > OK, can you please repost the patch with Borislav's Acked-by and Tested-by
> > and add some more Intel people to the CC list?
> > 
> 
> Sure, I'll do that. Thank you.
> But are we not going to consider a cleaner/correct solution such as the
> one proposed here:
> http://permalink.gmane.org/gmane.linux.kernel/1199494
> 
> Well, honestly I don't mean to be stubborn, but somehow, knowing that
> there are issues with my patch doesn't make me feel very comfortable
> going with it, especially when there is another approach, which I
> believe can fix the issue properly, without undesirable side-effects.
> 
> I agree that the issues are mostly some corner cases, so if you want a
> quick fix for now, I guess we can go with this patch and then later on
> follow-up with a proper solution to this whole problem.

It ultimately is your call.  If you feel more comfortable with the
alternative, just post that one instead.

Thanks,
Rafael
