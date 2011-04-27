Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab1D0Wla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:41:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56561 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab1D0Wl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:41:29 -0400
Date: Thu, 28 Apr 2011 00:41:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
Message-ID: <20110427224125.GR16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com> <4DB85596.4070105@canonical.com> <38255.1303937247@localhost> <4DB896B5.7090506@linux.intel.com> <1303943578.22777.32.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303943578.22777.32.camel@wwguy-ubuntu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> iwlwifi-5000-5.ucode is target to fix a 11n related issue we seen in the
> field (especially for Ubuntu), so it is important for people to use -5
> version of uCode. in order to allow driver to pick up the correct uCode
> (-5), we need to move the maximum API version to "5" which is what this
> patch does

But this means that anyone who just updates the kernel without
having the new firmware will lose their wireless. Not good.
longterm is not supposed to break existing userland like this

Possible would be a patch to try 5 first and then fall back to 
the older version. But that's not what this patch does, correct?

-Andi
