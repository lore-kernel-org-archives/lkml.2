Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0ERGPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:15:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42041 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0ERGPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:15:18 -0400
Date: Tue, 18 May 2010 08:15:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/cpu changes for v2.6.35
Message-ID: <20100518061512.GA17740@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20100517225225.GA32562@elte.hu>
 <20100517225426.GA1720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100517225426.GA1720@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, May 18, 2010 at 12:54:26AM +0200

Hi Ingo,

> * Ingo Molnar <mingo@elte.hu> wrote:

[..]

>       x86, k8: Fix build error when K8_NB is disabled

[..]

>       x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

[..]

>       powernow-k8: Fix frequency reporting

those three are already in Linus' tree since they were urgent fixes and
had to be sent ASAP. Now I don't know whether git will skip them when
merging or will cause unneeded merge conflicts (a small superficial test
I did here caused merge conflicts) ... anyways, just a heads-up.

-- 
Regards/Gruss,
    Boris.
