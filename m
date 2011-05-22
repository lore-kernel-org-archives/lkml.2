Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1EVKkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:40:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56965 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1EVKj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:39:57 -0400
Date: Sun, 22 May 2011 12:39:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com, gorcunov@openvz.org,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86, apic: apicdriver probe cleanups - V2
Message-ID: <20110522103942.GA2937@elte.hu>
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Updated patchset for cleaning up apic probe sequence by using apicdriver
> section.
> 
> Changes from V1:
>  * split up the patch into four small patches
>  * misc cleanups, specifying section alignment, removing duplicate messages
>    (from Cyrill and Yinghai's review comments)
>  * fixed a crash on smaller x64 systems

Ok, this split-up looks a lot nicer. Applied - thanks guys!

	Ingo
