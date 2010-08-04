Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab0HDHeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:34:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51811 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab0HDHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:34:36 -0400
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
References: <20100804070647.GB24064@verge.net.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 00:34:29 -0700
In-Reply-To: <20100804070647.GB24064@verge.net.au> (Simon Horman's message of "Wed\, 4 Aug 2010 16\:06\:48 +0900")
Message-ID: <m17hk6de62.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

> Hi,
>
> After all the excitement of relocating kexec-tools from
> one location on kernel.org to another last week it was
> suggested to me by Michael Neuling that the merging
> kexec-tools into the kernel tree would be a good idea.
>
> Given that there have been a bunch of issues with kexec
> on power that this would resolve. and there is precedence
> for tools in the kernel tree, this sounds entirely reasonable to me.
> So with my kexec-tools maintainer hat on, I would like to start
> a conversation about this.

What are the issues with kexec on power?  Did someone fail to maintain
ABI compatibility?

The interface isn't even supposed to be linux specific, so I can't
imagine what would motivate moving this into the kernel tree.

I'm afraid that someone has a good answer for why their lives would be
simpler if /sbin/kexec was in the kernel tree and I will be absolutely
horrified and about someones stupidity when I hear that answer.

Eric
