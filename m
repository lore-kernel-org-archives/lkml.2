Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0IVS0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:26:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:60212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0IVS0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,219,1283756400"; 
   d="scan'208";a="327562978"
Message-ID: <4C9A4A4F.3060909@linux.intel.com>
Date: Wed, 22 Sep 2010 11:26:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        greg@kroah.com
Subject: Re: Early console confusion
References: <4C7B0578.8090807@kernel.org> <201009221044.58735.bjorn.helgaas@hp.com> <4C9A3487.6080005@zytor.com> <201009221222.00475.bjorn.helgaas@hp.com>
In-Reply-To: <201009221222.00475.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 11:21 AM, Bjorn Helgaas wrote:
> 
> I think earlycon and earlyprintk have minimal backwards compatibility
> problems, since they're mostly for developers.  And if we decided
> we did need to keep them, they could be undocumented and implemented
> on top of "console=" with the appropriate explicit device.
> 

The problem is that they're actually hard-coded into the firmware of
some embedded devices.

	-hpa
