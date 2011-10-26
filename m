Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1JZEGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:06:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:14387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1JZEGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,407,1315206000"; 
   d="scan'208";a="82275993"
Subject: Re: iwlagn is getting very shaky
From: wwguy <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111026040332.GF24956@gamma.logic.tuwien.ac.at>
References: <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319119852.2111.2.camel@wwguy-ubuntu>
	 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	 <20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	 <1319601333.14693.19.camel@wwguy-ubuntu>
	 <20111026040332.GF24956@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 21:00:54 -0700
Message-ID: <1319601654.14693.20.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 21:03 -0700, Norbert Preining wrote:
> On Di, 25 Okt 2011, wwguy wrote:
> > so this is different problem, right? it looks different compare to what
> > you described before which is cause by queue stopped.
> 
> I assume that this is a different regression concerning 3.1.0 released.
> 
> But *I* cannot be sure about it ;-)
> 
Are you seeing this without suspend/resume?

Thanks
Wey

