Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1GZDtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 23:49:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:7304 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GZDtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 23:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,266,1309762800"; 
   d="scan'208";a="34470680"
Message-ID: <4E2E3947.2040806@linux.intel.com>
Date: Mon, 25 Jul 2011 20:49:27 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107241223560.2702@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/24/2011 03:33 AM, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt3 release.
> 
> Changes versus 3.0-rt2:
> 
>   * Fix earlyprintk really


Confirmed. The following kernel boot parameters now work correctly together:

"console=tty0 console=ttyS1,115200n8 earlyprintk=ttyS1,115200"

Thanks Thomas,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
