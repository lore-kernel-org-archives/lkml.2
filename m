Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab1JTNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:50:36 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1JTNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:50:35 -0400
Subject: Re: iwlagn is getting very shaky
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <56FBBFB3-4DC9-4CB6-939A-8F0130EBCB9B@logic.at>
References: <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
	 <1319038282.25023.21.camel@wwguy-ubuntu>
	 <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319096418.3959.1.camel@jlt3.sipsolutions.net>
	 <56FBBFB3-4DC9-4CB6-939A-8F0130EBCB9B@logic.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 15:50:25 +0200
Message-ID: <1319118625.3959.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 22:45 +0900, Norbert Preining wrote:
> Hi Johannes,
> 
> > did you have scan information for these APs?
> 
> Unfortunately not, but I can get them when I am back on Wednesday, if you want.
> 
> Just let me know what exactely.

Just "iw wlan0 scan" output or so. Basically I just want the BSSID/freq
to see which APs are on which band.

johannes

