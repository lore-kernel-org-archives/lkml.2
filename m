Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0HDISb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:18:31 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:36097 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0HDISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:18:08 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 04:18:08 EDT
Date: Wed, 4 Aug 2010 10:08:13 +0200
From: Bernhard Walle <bernhard@bwalle.de>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100804080813.GA20178@bwalle.de>
Mail-Followup-To: Simon Horman <horms@verge.net.au>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Michael Neuling <mikey@neuling.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <20100804070647.GB24064@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804070647.GB24064@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Simon Horman <horms@verge.net.au> [2010-08-04 09:06]:
> 
> Given that there have been a bunch of issues with kexec
> on power that this would resolve. and there is precedence
> for tools in the kernel tree, this sounds entirely reasonable to me.
> So with my kexec-tools maintainer hat on, I would like to start
> a conversation about this.

Well, honestly I don't understand the reason behind it.

If it's about dependencies between the kexec binary and the kernel
version -- there are also dependencies between makedumpfile and crash to
the kernel version. Should we move makedumpfile and crash in the kernel
tree, too (which means that we have a GDB copy in the kernel tree)?


Regards,
Bernhard
