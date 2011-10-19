Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1JSGsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:48:35 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34687 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JSGse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:48:34 -0400
Date: Wed, 19 Oct 2011 15:48:18 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com> <1319003710.31823.53.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319003710.31823.53.camel@wwguy-huron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> > >> loaded firmware version 8.83.5.1 build 33692 (EXP)
> > >>
> 
> looks like you are using experimental version of uCode, but by saying
> that, I don't think i will make much differences
> 
> so could you dump the tx queue to see if it is the similar problem what
> Norbert point out

Not sure what you mean Wey, should *I* Norbert use the default firmware
and try to reproduce it? Ir should Pekka try to reproduce it with
normal firmware? Or with both?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WROOT (n.)
A short little berk who thinks that by pulling on his pipe and gazing
shrewdly at you he will give the impression that he is infinitely wise
and 5 ft 11 in.
			--- Douglas Adams, The Meaning of Liff
