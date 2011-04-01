Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1DALd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:33:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1DALdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:33:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 13:32:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <201103301906.42429.arnd@arndb.de> <201103311723.02301.arnd@arndb.de> <alpine.LFD.2.00.1103311826070.22418@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103311826070.22418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011332.35618.arnd@arndb.de>
X-Provags-ID: V02:K0:CmAF22kUsHphpJ9XGRiguEBBMyOiIuHKBt2szNZTSrW
 il4sjGDpGB0mdSEba/nUEOq0nHMOyUuZo9cOeufLkm59VxNSJM
 FhKEMpIfGKVMqgP09IuIJ5Z5B458Fs1gRTbn2g3FAZ4WPH+3Ll
 BHg4b1xSwFYmyASW8g9qAejq4ZJ2IyTwHhIFzEZsfUHKsvydCH
 LYvOIWJlq0gOM7oB8KVjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Thomas Gleixner wrote:
> On Thu, 31 Mar 2011, Arnd Bergmann wrote:
>
> Right, but the problem starts in way simpler areas like irq chips and
> gpio stuff, where lots of the IP cores are similar and trivial enough
> to be shared across many SoC families.

Yes, I'm sure that there are more obvious examples than the ones I've
given, those were just the ones that I had noticed myself.
 
> Even the OMAP "consolidated" code is silly:
>
> But the code above has 6 cases in the switch because nobody abstracted
> it out consequently. Not to talk about the ifdef mess.

Nice illustration.

	Arnd
