Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1ISUzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:55:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:45358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1ISUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:55:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50291046"
Message-ID: <4E77AC54.2080305@linux.intel.com>
Date: Mon, 19 Sep 2011 13:55:48 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: Huang Ying <ying.huang@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add IRQ context simulation in mce-inject
References: <4E7707DA.6080504@linux.intel.com>
In-Reply-To: <4E7707DA.6080504@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/2011 2:14 AM, Chen Gong wrote:
> From: Chen Gong <gong.chen@linux.intel.com>
>
> Current mce-inject can simulate some kinds of scenarios, such as
> one CPU working in process context, and other CPUs working in NMI
> context. To extend the coverage of test range, a new IRQ context
> for other CPUs is added.

Looks good to me.
-Andi

