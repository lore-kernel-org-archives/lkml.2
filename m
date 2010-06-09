Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0FIB6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:58:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab0FIB57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:57:59 -0400
Date: Tue, 8 Jun 2010 18:57:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
In-Reply-To: <20100608182456.3e681359@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.1006081855170.4506@i5.linux-foundation.org>
References: <20100608221901.GA25294@srcf.ucam.org> <alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org> <20100608182456.3e681359@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Jesse Barnes wrote:
> 
> FWIW this is the "make ironlake go fast" driver.  It interacts with the
> i915 driver to increase graphics performance significantly.  But yeah,
> Matthew and I didn't get it integrated into his tree in time for the
> merge window, so I understand if you don't want it right now.

I'm not great at all the intel code-names. Is ironlake the expected-Q4 
on-die GPU or the current one? 

Not that I'd prefer to pull it even if it's the current one, but if it's 
the next-gen one then we're in even less of a hurry, I think. 

		Linus
