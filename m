Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab1E0JjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:39:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1E0JjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:39:10 -0400
Date: Fri, 27 May 2011 11:38:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527093853.GI21386@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110526203502.GK29496@redhat.com>
 <20110526204030.GL29496@redhat.com>
 <1306442674.2279.29.camel@dan>
 <20110526205549.GM29496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526205549.GM29496@redhat.com>
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


* Vivek Goyal <vgoyal@redhat.com> wrote:

> > Is it common to run kexec-tools as non-root?  It may be necessary 
> > to restrict this interface to root when randomization is used 
> > (keep in mind nobody's going to force you to turn this on by 
> > default, at least for the foreseeable future).
> 
> kexec-tools runs as root. And I see that /proc/iomem permissions 
> are also for root only. So it probably is a non-issue.

it might be an issue to keep in mind for later projects that try to 
lock down root itself from being able to patch the kernel (other than 
rebooting the box), using signed modules, disabled direct-ioport 
access, and other hardened facilities.

Thanks,

	Ingo
