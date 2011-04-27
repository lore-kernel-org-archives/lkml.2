Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab1D0WrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:47:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51818 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab1D0WrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:47:00 -0400
Date: Thu, 28 Apr 2011 00:46:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
Message-ID: <20110427224659.GS16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com> <4DB85596.4070105@canonical.com> <38255.1303937247@localhost> <4DB896B5.7090506@linux.intel.com> <1303943578.22777.32.camel@wwguy-ubuntu> <20110427224125.GR16484@one.firstfloor.org> <1303944143.22777.35.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303944143.22777.35.camel@wwguy-ubuntu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current driver behavior, try to load the maximum version first, if
> does not exist, then fall back to the older version. This patch just
> increase the maximum API version to "5", so driver will try to load the
> version "5" first.

Okay thanks for the explanation. I will keep this patch then.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
