Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab1D0WgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:36:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:12778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073Ab1D0WgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,276,1301900400"; 
   d="scan'208";a="915323028"
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
From: wwguy <wey-yi.w.guy@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
In-Reply-To: <4DB896B5.7090506@linux.intel.com>
References: <20110426212.641772347@firstfloor.org>
	 <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
	 <4DB85596.4070105@canonical.com> <38255.1303937247@localhost>
	 <4DB896B5.7090506@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 15:32:58 -0700
Message-ID: <1303943578.22777.32.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
On Wed, 2011-04-27 at 15:20 -0700, Andi Kleen wrote:
> > I can't speak to Ubuntu, but I hit this on Fedora Rawhide a while ago, they
> > ended including several versions so different kernels would work OK:
> >
> > % rpm -ql iwl5000-firmware
> > /lib/firmware/iwlwifi-5000-1.ucode
> > /lib/firmware/iwlwifi-5000-2.ucode
> > /lib/firmware/iwlwifi-5000-5.ucode
> 
> I don't want people require to install new firmware for .35. This sounds 
> like I should
> drop this patch. Wey-yi?
> 

iwlwifi-5000-5.ucode is target to fix a 11n related issue we seen in the
field (especially for Ubuntu), so it is important for people to use -5
version of uCode. in order to allow driver to pick up the correct uCode
(-5), we need to move the maximum API version to "5" which is what this
patch does

Thanks
Wey



