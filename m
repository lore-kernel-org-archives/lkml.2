Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1A1Ogy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:36:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:39092 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1A1Ogx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:36:53 -0500
Message-Id: <b7da2f$q91n95@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,392,1291622400"; 
   d="scan'208";a="881909037"
Date: Fri, 28 Jan 2011 14:36:43 +0000
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
Cc: dri-devel@lists.freedesktop.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1101260634300.10774@localhost6.localdomain6> <b9dded$hp9kfu@orsmga002.jf.intel.com> <alpine.DEB.2.00.1101270641490.2923@localhost6.localdomain6> <b9dded$hpa5rf@orsmga002.jf.intel.com> <alpine.DEB.2.00.1101270710510.17636@localhost6.localdomain6> <1bdc18$jdgfni@fmsmga002.fm.intel.com> <alpine.DEB.2.00.1101270840380.2736@localhost6.localdomain6> <0d30dc$ksovh8@orsmga001.jf.intel.com> <alpine.DEB.2.00.1101270854420.4898@localhost6.localdomain6> <b7da2f$q8lpcn@fmsmga001.fm.intel.com> <alpine.DEB.2.00.1101271634260.2761@localhost6.localdomain6> <alpine.DEB.2.00.1101271730400.2583@localhost6.localdomain6> <849307$bbem1h@azsmga001.ch.intel.com> <alpine.DEB.2.00.1101280421430.2739@localhost6.localdomain6> <0d30dc$kt3gd6@orsmga001.jf.intel.com> <alpine.DEB.2.00.1101280850550.2796@localhost6.localdomain6> <849307$bbh907@azsmga001.ch.intel.com> <alpine.DEB.2.00.1101280928170.2760@localhost6.localdomain6>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.DEB.2.00.1101280928170.2760@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 09:32:04 -0500 (EST), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > fix your boot issue or do we need to go back to using uncached:
> >
> > +       return ioremap(phys, size);
> 
>   is that the next change you want me to try?

Yes. (Replacing the current return ioremap_*(phys, size).)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
