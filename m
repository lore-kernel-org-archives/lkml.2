Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2EWQrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:47:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:54028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2EWQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:46:57 -0400
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        frank.arnold@amd.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20120523164404.GA18284@liondog.tnic>
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
	 <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
	 <1337789898.9783.19.camel@laptop>
	 <20120523162335.GO14757@aftab.osrc.amd.com>
	 <1337790667.9783.29.camel@laptop>  <20120523164404.GA18284@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:46:45 +0200
Message-ID: <1337791605.9783.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 18:44 +0200, Borislav Petkov wrote:

> FWIW, I can change it if you feel too strongly about it, I don't really
> care that much.

I don't care much at the moment, I might if I'm ever forced to actually
read the MCE code, but until that time I'll crawl back into my
corner :-)

