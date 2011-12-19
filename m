Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1LSXMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:12:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:26740 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1LSXMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:12:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103987784"
Date: Mon, 19 Dec 2011 15:12:22 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com, trenn@suse.de,
        kay.sievers@vrf.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 08/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111219231222.GA31168@tassilo.jf.intel.com>
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org>
 <1324334865-30459-9-git-send-email-andi@firstfloor.org>
 <20111219230341.GA570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219230341.GA570@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking closer at this one, I think we could possibly just autoload based on the PCI IDs
> in gx_chipset_tbl, and remove the cpu vendor checking entirely.
> Pretty sure those Cyrix PCI devices won't show up anywhere else.

Ok. Will do that.
 
> Otherwise, we could narrow the range this gets loaded on to Cyrix Fam 4 model 5, and
> NatSemi Fam 5, model 4.  (afaik, that covers all the possible cpus this driver works on)


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
