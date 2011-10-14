Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1JNH6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:58:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:8334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721Ab1JNH6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62882669"
Date: Fri, 14 Oct 2011 10:59:27 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: sameo@linux.intel.com
Cc: alan@linux.intel.com, sameo@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, mrst: add platform support for MSIC MFD driver
Message-ID: <20111014075927.GD23578@intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
 <dfe26ef675afbc2ce21b54f5c23b94cb00fc4032.1315399396.git.mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfe26ef675afbc2ce21b54f5c23b94cb00fc4032.1315399396.git.mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Sep 07, 2011 at 04:06:52PM +0300, Mika Westerberg wrote:
> The MSIC MFD driver creates platform devices for MSIC device drivers so we
> don't need to create them in platform code anymore.
> 
> This patch adds a new runtime check which determines whether we are running
> on a Medfield platform and enables the MSIC MFD driver accordingly.

There is a fix in 3.1 which conflicts this patch. The fix is 153b19a3b9fd8b
(x86, mrst: use a temporary variable for SFI irq) which is needed for
Medfield platforms to get kexec working.

If you like, I can send you an updated version of this patch which doesn't
conflict. Please let me know.
