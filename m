Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1LHPKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:10:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:46388 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1LHPKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:10:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83639388"
Date: Thu, 8 Dec 2011 07:10:34 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, trenn@suse.de,
        davej@redhat.com
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem
 (needed for CPU modaliases)
Message-ID: <20111208151034.GA28146@alboin.amr.corp.intel.com>
References: <1323309517.979.8.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323309517.979.8.camel@mop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 02:58:37AM +0100, Kay Sievers wrote:
> This patch is work-in-progress and just posted to coordinate with Andi
> Kleen's current export of CPU modaliases. It boots my x86_64 workstation
> fine, nothing else is tested.

Once this is in I can move the cpu modaliases from cpuid into the normal cpu
devices.  Right now either way works.

Getting rid of sysdevs is definitely good.

... Haven't read it all, but the parts I read look good.

-Andi
