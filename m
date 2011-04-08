Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1DHPp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:45:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1DHPpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:45:55 -0400
Date: Fri, 8 Apr 2011 17:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86/mrst: correct pin to irq mapping
Message-ID: <20110408154540.GC17934@elte.hu>
References: <1302201172-1254-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302201172-1254-1-git-send-email-jacob.jun.pan@linux.intel.com>
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


* Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:

> Set mp_bus_not_pci bit to allow 1:1 mapping of pin2irq on Moorestown.
> Refer to discussion in:
> https://lkml.org/lkml/2010/6/10/70
> 
> Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/platform/mrst/mrst.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Could you please improve the changelog to explain to the reader:

 - why has this change been done
 - what are the effects on users (if any)
 - what is the urgency of the patch (needed for .39, or can wait for .40)

lkml.org links may or may not work in the future, we really need proper 
background information in changelogs.

Thanks,

	Ingo
