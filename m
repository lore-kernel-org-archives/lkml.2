Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0HTSj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:39:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:45342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0HTSjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,240,1280732400"; 
   d="scan'208";a="315143485"
Message-ID: <4C6ECBEE.5000301@linux.intel.com>
Date: Fri, 20 Aug 2010 11:39:42 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Wan, Huaxu" <huaxu.wan@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 5/5] Package Level Thermal Control and Power Limit Notification:
 pkgtemp doc
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com>	<4C485DF1.5050407@linux.intel.com>	<20100722162222.GA22450@linux-os.sc.intel.com>	<20100722172726.GA4914@ericsson.com>	<20100722175225.GB22450@linux-os.sc.intel.com>	<20100722185814.GA5235@ericsson.com>	<20100722212111.GC22450@linux-os.sc.intel.com>	<20100819174632.239aed93@hyperion.delvare>	<20100819162719.GB4160@ericsson.com>	<20100819205120.GA22602@linux-os.sc.intel.com> <20100820103356.01c9907f@hyperion.delvare>
In-Reply-To: <20100820103356.01c9907f@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 01:33 AM, Jean Delvare wrote:
> 
> Side question: is it safe to assume a maximum of 2 siblings per core on
> Intel x86 CPUs?
> 

That is true for all current CPUs, but is not guaranteed for the future.

	-hpa
