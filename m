Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1JSHE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:04:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:16070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab1JSHEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64635250"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 23:13:56 -0700
Message-ID: <1319004836.31823.57.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 23:46 -0700, Norbert Preining wrote:
> On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> > it is very interesting, for sure there is a bug here which cause NIC
> > stop working, if you look at the tx queue, hwq 0 is stop, which mean
> > nothing go out. I am not sure how we get into this? yes, most likely
> 
> Yes, that is my obervation, too. Nothing goes out, so reassociation
> does not succeed.
> 
> > Could you help me how to repro this problem?
> 
> Not really, besides you come here to my university ;-)
> I have this problem currently only with the routers here at
> the university, not with other routers.
> 
> Any other way I can provide you help?

Could you please let me know the brand/model of the AP which having
problem. Also the configuration of your NIC also help.

also, when you say you don't have problem with other router, could you
please be more clear, are those APs having the similar functions as the
one you have in university, or different? 

Thanks
Wey

> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> SKENFRITH (n.)
> The flakes of athlete's foot found inside socks.
> 			--- Douglas Adams, The Meaning of Liff


