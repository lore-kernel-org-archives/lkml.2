Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2AYWEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:04:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:24729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2AYWEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:04:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99726073"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
In-Reply-To: <20120125134947.GF13655@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
	 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
	 <20120125134947.GF13655@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 25 Jan 2012 14:04:08 -0800
Message-ID: <1327529048.2327.17.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 08:49 -0500, Josh Boyer wrote:
> [    0.000000] IOAPIC[1]: apic_id 2, version 255, address 0xfec28000, GSI 24-279

This looks indeed like a bogus entry probably returning all 1's for
RTE's etc. Can you please send me a dmesg with "apic=verbose" boot
parameter?

thanks,
suresh

