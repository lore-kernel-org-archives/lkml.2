Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1D0WpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:45:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:54600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025Ab1D0WpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,276,1301900400"; 
   d="scan'208";a="915325964"
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
From: wwguy <wey-yi.w.guy@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
In-Reply-To: <20110427224125.GR16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
	 <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
	 <4DB85596.4070105@canonical.com> <38255.1303937247@localhost>
	 <4DB896B5.7090506@linux.intel.com> <1303943578.22777.32.camel@wwguy-ubuntu>
	 <20110427224125.GR16484@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 15:42:23 -0700
Message-ID: <1303944143.22777.35.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 15:41 -0700, Andi Kleen wrote:
> > iwlwifi-5000-5.ucode is target to fix a 11n related issue we seen in the
> > field (especially for Ubuntu), so it is important for people to use -5
> > version of uCode. in order to allow driver to pick up the correct uCode
> > (-5), we need to move the maximum API version to "5" which is what this
> > patch does
> 
> But this means that anyone who just updates the kernel without
> having the new firmware will lose their wireless. Not good.
> longterm is not supposed to break existing userland like this
> 
> Possible would be a patch to try 5 first and then fall back to 
> the older version. But that's not what this patch does, correct?
> 
The current driver behavior, try to load the maximum version first, if
does not exist, then fall back to the older version. This patch just
increase the maximum API version to "5", so driver will try to load the
version "5" first.

Thanks
Wey 


