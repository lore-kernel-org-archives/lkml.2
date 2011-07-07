Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1GGLky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:40:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1GGLkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:40:51 -0400
Date: Thu, 7 Jul 2011 13:40:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com
Subject: Re: [PATCH v2] efi: Fix argument types for SetVariable()
Message-ID: <20110707114036.GA10296@elte.hu>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1309985329-15034-1-git-send-email-mjg@redhat.com>
 <20110707093305.GA15058@elte.hu>
 <20110707113845.GA10882@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707113845.GA10882@srcf.ucam.org>
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Jul 07, 2011 at 11:33:05AM +0200, Ingo Molnar wrote:
> 
> > Please send a patch against latest -tip, we've got EFI changes in 
> > tip:x86/efi and your patch conflicts.
> 
> The original version introduced a warning, thsi was intended to replace 
> it. Is -tip not rebased?

No, it is not - please send a delta patch.

Thanks,

	Ingo
