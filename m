Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1JSHaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:30:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:45101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1JSHaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:30:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="64477079"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
	 <1319003710.31823.53.camel@wwguy-huron>
	 <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 23:39:32 -0700
Message-ID: <1319006372.31823.61.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 23:48 -0700, Norbert Preining wrote:
> On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> > > >> loaded firmware version 8.83.5.1 build 33692 (EXP)
> > > >>
> > 
> > looks like you are using experimental version of uCode, but by saying
> > that, I don't think i will make much differences
> > 
> > so could you dump the tx queue to see if it is the similar problem what
> > Norbert point out
> 
> Not sure what you mean Wey, should *I* Norbert use the default firmware
> and try to reproduce it? Ir should Pekka try to reproduce it with
> normal firmware? Or with both?
> 
just got a idea, could you try to revert
commit#68b993118f715cc631b62b6a50574e4701fe9ace

not sure you can cleanly revert it, please let me know if you got
problem


Thanks
Wey
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Liot sure yu ve & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> WROOT (n.)
> A short little berk who thinks that by pulling on his pipe and gazing
> shrewdly at you he will give the impression that he is infinitely wise
> and 5 ft 11 in.
> 			--- Douglas Adams, The Meaning of Liff


