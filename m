Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0CTUuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:50:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0CTUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:50:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>, Sachin Sant <sachinp@in.ibm.com>
Subject: Re: 2.6.34-rc2: cpu hotplug test failure on x86_64
Date: Sat, 20 Mar 2010 21:53:16 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
References: <4BA50319.3040301@in.ibm.com> <1269106149.9440.517.camel@laptop>
In-Reply-To: <1269106149.9440.517.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202153.16547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 March 2010, Peter Zijlstra wrote:
> On Sat, 2010-03-20 at 22:47 +0530, Sachin Sant wrote:
> > Running cpu hotplug tests on a x86_64 box results in
> > the following BUG.
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> > IP: [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67
> 
> I guess something like the below might work.

Not really.  Sachin, please try this patch instead:
https://patchwork.kernel.org/patch/87189/

Rafael
