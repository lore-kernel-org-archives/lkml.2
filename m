Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1JSMty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:49:54 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:48997 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1JSMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:49:52 -0400
Date: Wed, 19 Oct 2011 21:49:31 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
References: <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com> <1319003710.31823.53.camel@wwguy-huron> <20111019064818.GB14817@gamma.logic.tuwien.ac.at> <1319004938.31823.59.camel@wwguy-huron> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319006372.31823.61.camel@wwguy-huron> <1319004938.31823.59.camel@wwguy-huron> <1319004836.31823.57.camel@wwguy-huron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey,

On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> Could you please let me know the brand/model of the AP which having
> problem. Also the configuration of your NIC also help.

I will try to find out as many information as possible tomorrow
when I am back at university. I think the routers are hanging on
the ceiling, so I can somehow check what they are.

> also, when you say you don't have problem with other router, could you
> please be more clear, are those APs having the similar functions as the
> one you have in university, or different? 

Well, at home I have a normal WLAN router, one where you plug on
the one side some upstream cable and then you have several downstream
cable (eth) and wlan.

On the university there is probably much more system since there are many
APs and one can easily wander around. I will try to find out as
much as possible.

Anything one can to wiht iwconfig, ethercap or similar tools?

> just got a idea, could you try to revert
> commit#68b993118f715cc631b62b6a50574e4701fe9ace

I try it tomorrow and let you know. I tried for now to revert it
directly without success, but I will try to do it by hand. If
I have problems I let you know. Tomorrow, now is break time ;-)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
DES MOINES (pl.n.)
The two little lines which come down from your nose.
			--- Douglas Adams, The Meaning of Liff
