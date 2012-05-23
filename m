Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2EWQbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:31:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab2EWQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:31:13 -0400
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, frank.arnold@amd.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20120523162335.GO14757@aftab.osrc.amd.com>
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
	 <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
	 <1337789898.9783.19.camel@laptop>
	 <20120523162335.GO14757@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:31:07 +0200
Message-ID: <1337790667.9783.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 18:23 +0200, Borislav Petkov wrote:
> I know but I have the exact bit name from the BKDG in the comment above
> - CntP - and this is used only at one place - here - so no need for the
> defines, IMHO. 

Yes, but CntP is such a good name that it actually forced me to look at
the BKDG to figure out wtf it meant ;-)

