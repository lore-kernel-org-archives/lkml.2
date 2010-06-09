Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0FIB0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:26:10 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:57365 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751894Ab0FIB0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:26:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fvfr1L5R/oeHUldxbTK3WVYFA6cIh6lM29NzAdu5rifcp37ybxO3sD59CpDowzX7mIik9tSZOKJi6FMcxSWJBT0LhnY6mYNPkgfwGeH3BIAg9XjT1r1A2PnR+6nrR1wi;
Date: Tue, 8 Jun 2010 18:24:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
Message-ID: <20100608182456.3e681359@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org>
References: <20100608221901.GA25294@srcf.ucam.org>
	<alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 18:10:33 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Jun 2010, Matthew Garrett wrote:
> > 
> > Some fixes for error paths, some config fixes, a minor update to hp-wmi 
> > that deals with some annoying corner cases like AC adapter events being 
> > interpreted as brightness down keystrokes and the Intel IPS driver. This 
> > requires a small addition to the timer API but doesn't modify any 
> > existing code. Should all be entirely low impact.
> 
> [ Very shortly after sending out an email about how most developers 
>   probably don't end up reading much of lkml, and thus having missed all 
>   the other threads on this subject ]
> 
> Everybody repeat after me: "After -rc2 I won't be taking patches or pull 
> requests that aren't regression fixes or fixes to major bugs (oopses or 
> security etc)".
> 
> See the -rc2 announcement, or any of (by now) roughly ten different 
> threads on lkml and a couple of other mailing lists as response to pull 
> requests etc ;^)
> 
> And yes, that very much does include new drivers. Especially if they end 
> up affecting anything else (but in al honesty, I probably wouldn't take it 
> now even if it was entirely standalone).

FWIW this is the "make ironlake go fast" driver.  It interacts with the
i915 driver to increase graphics performance significantly.  But yeah,
Matthew and I didn't get it integrated into his tree in time for the
merge window, so I understand if you don't want it right now.

-- 
Jesse Barnes, Intel Open Source Technology Center
