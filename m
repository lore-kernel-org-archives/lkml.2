Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1KBEO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 00:14:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:18974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1KBEOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 00:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,441,1315206000"; 
   d="scan'208";a="80298190"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111102031345.GA10851@gamma.logic.tuwien.ac.at>
References: <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319119852.2111.2.camel@wwguy-ubuntu>
	 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	 <20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	 <1319601333.14693.19.camel@wwguy-ubuntu>
	 <20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	 <20111102031345.GA10851@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 20:21:41 -0700
Message-ID: <1320204101.31823.140.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

On Tue, 2011-11-01 at 20:13 -0700, Norbert Preining wrote:
> Hi all,
> 
> On Mi, 26 Okt 2011, Norbert Preining wrote:
> > On Di, 25 Okt 2011, wwguy wrote:
> > > so this is different problem, right? it looks different compare to what
> > > you described before which is cause by queue stopped.
> > 
> > I assume that this is a different regression concerning 3.1.0 released.
> 
> Is there any progress on that? Currently linux git status is unusable
> with respect to iwlwifi?
> 
> Are there any changes planned before rc1?
> 
after the firmware reloaded, is the traffic resume? or it is continuous
without traffic?

Looks like the different "queue stuck" problem you are seeing. you
mention you only seeing this at university but not home. So what the
differences are?
what Band/channel you are using, also, if you disable 11n, are you still
seeing the problem?

you also mention it is might related to suspend/resume, could you please
give a better description why you think it might be related 

Thanks
Wey



