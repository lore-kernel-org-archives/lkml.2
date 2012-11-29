Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2K2WqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:46:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37205 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752859Ab2K2WqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:46:11 -0500
Message-ID: <1354229172.1700.18.camel@joe-AO722>
Subject: Re: [PATCH V2 00/23] printk: refactoring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>,
        "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 29 Nov 2012 14:46:12 -0800
In-Reply-To: <20121129142143.22886573.akpm@linux-foundation.org>
References: <cover.1351135988.git.joe@perches.com>
	 <1351864140.3537.1.camel@joe-AO722> <1352760850.18715.8.camel@joe-AO722>
	 <20121112152621.eb14d7f0.akpm@linux-foundation.org>
	 <1354226895.1700.12.camel@joe-AO722>
	 <20121129142143.22886573.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 14:21 -0800, Andrew Morton wrote:
> On Thu, 29 Nov 2012 14:08:15 -0800
> Joe Perches <joe@perches.com> wrote:
> > Well, it's getting to be too late for this series.
> 
> Yeah sorry, stuff got in the way, then people patched printk.c.

No worries.

> > When would be the best time to resubmit and get this
> > into -next?
> 
> I think at rc1.  Then if all is OK I'd aim at a merge for rc2 or rc3
> because these patches are rather a pain to keep alive.

It's still a scheduling issue with Kay and Jan's patches.
Does anyone have any idea if/when those patches are going in?


