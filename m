Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0CVAm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:42:56 -0400
Received: from mga07.intel.com ([143.182.124.22]:43408 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536Ab0CVAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,284,1267430400"; 
   d="scan'208";a="257100864"
Message-ID: <4BA6BD0A.6030303@linux.intel.com>
Date: Sun, 21 Mar 2010 17:42:50 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: =?ISO-8859-15?Q?Robert_Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
References: <1268399863.3407.15.camel@localhost> <201003182143.22929.trenn@suse.de> <1268985679.3395.47.camel@localhost> <201003202237.57477.trenn@suse.de>
In-Reply-To: <201003202237.57477.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2010 14:37, Thomas Renninger wrote:

> It also seem to be (hopefully) a minor feature for timechart, so this should
> not hurt that much (yet).

It's actually a major feature for timechart, and one of the key things I and a bunch of others
inside Intel use timechart for.

