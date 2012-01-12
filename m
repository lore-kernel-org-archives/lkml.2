Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2ALCLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:11:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:2183 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab2ALCLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:11:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="97259430"
Message-ID: <4F0E4147.7000903@linux.intel.com>
Date: Thu, 12 Jan 2012 10:11:19 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: "linux-x86_64@vger.kernel.org" <linux-x86_64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CPU clock throttled prints..
References: <D6D887BA8C9DFF48B5233887EF04654109E855E9B4@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654109E855E9B4@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/7/5 13:36, R, Durgadoss 写道:
> Hi All,
>
> I am getting these prints in my Atom based device, running 2.6.35 kernel.
>
> [  350.084005] CPU0: Temperature above threshold, cpu clock throttled (total
> events = 26)
> [  350.084029] CPU1: Temperature above threshold, cpu clock throttled (total
> events = 26)
> [  350.085293] CPU0: Temperature/speed normal
> [  350.085311] CPU1: Temperature/speed normal
>
> Seems like these are from therm_throt.c and the flow for this,
> Starts from smp_thermal_interrupt(...) method.
>
> Can somebody tell me when this method gets called ?
> Also, does this actually throttle the CPU ?
>

try to apply this patch 29e9bf1841e4f (x86, mce, therm_throt: Don't report
power limit and package level thermal throttle events in mcelog)
