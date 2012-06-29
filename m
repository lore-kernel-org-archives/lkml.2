Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2F2WVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 18:21:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2F2WVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 18:21:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2] acpi: intel_idle : break dependency between modules
Date: Sat, 30 Jun 2012 00:27:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: lenb@kernel.org, trenn@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Colin Cross <ccross@android.com>
References: <201206271506.29034.trenn@suse.de> <201206282124.09857.rjw@sisk.pl> <4FED69BE.20707@linaro.org>
In-Reply-To: <4FED69BE.20707@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206300027.05175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 29, 2012, Daniel Lezcano wrote:
> On 06/28/2012 09:24 PM, Rafael J. Wysocki wrote:
> > On Thursday, June 28, 2012, Daniel Lezcano wrote:
> >> When the system is booted with some cpus offline, the idle
> >> driver is not initialized. When a cpu is set online, the
> >> acpi code call the intel idle init function. Unfortunately
> >> this code introduce a dependency between intel_idle and acpi.
> >>
> >> This patch is intended to remove this dependency by using the
> >> notifier of intel_idle. This patch has the benefit of
> >> encapsulating the intel_idle driver and remove some exported
> >> functions.
> >>
> >> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > 
> > This one looks good to me too.
> > 
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Thanks for the review Rafael.
> 
> > Len, are you going to take it?
> 
> Rafael, Len,
> 
> After the discussion [1], I put in place a tree at:
> 
> ssh://git.linaro.org/srv/git.linaro.org/git/people/dlezcano/cpuidle-next.git
> #cpuidle-next
> 
> I proposed this tree to group the cpuidle modifications and prevent the
> last minutes conflict when Len will apply them.
> 
> I also included the tree into linux-next for wider testing.

I can't speak for Len, but I'm not sure he'll like this.

Anyway, you seem to have the same material as Len in that tree, won't there
be any conflicts in linux-next?

Rafael
