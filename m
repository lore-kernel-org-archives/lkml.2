Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab2HMEPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 00:15:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:35019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab2HMEPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 00:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="185503643"
Date: Sun, 12 Aug 2012 21:15:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Betty Dall <betty.dall@hp.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor ID
 first
Message-ID: <20120813041534.GK2644@tassilo.jf.intel.com>
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org>
 <1344551691.10751.12.camel@ejdallLaptop>
 <50259FCE.4070205@zytor.com>
 <50287315.5010203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50287315.5010203@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If that is the case, there is a problem in the original code in
> arch/x86/kernel/aperture_64.c.The original code already stops scanning
> functions the first time it finds an invalid PCI class:

This was only for some AMD northbridges, since it worked there it should
be ok. The code is obsolete now for modern systems I believe.

-Andi
