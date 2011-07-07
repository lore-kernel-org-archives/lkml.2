Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1GGJdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:33:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1GGJdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:33:22 -0400
Date: Thu, 7 Jul 2011 11:33:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: [PATCH v2] efi: Fix argument types for SetVariable()
Message-ID: <20110707093305.GA15058@elte.hu>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1309985329-15034-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309985329-15034-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Matthew Garrett <mjg@redhat.com> wrote:

> The spec says this takes uint32 for attributes, not uintn.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> 
> This version fixes ia64 as well. 
> 
>  arch/ia64/kernel/efi.c      |    2 +-
>  arch/x86/platform/efi/efi.c |    2 +-
>  include/linux/efi.h         |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Please send a patch against latest -tip, we've got EFI changes in 
tip:x86/efi and your patch conflicts.

Thanks,

	Ingo
