Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0DMUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:43:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:27110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0DMUnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:43:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,199,1270450800"; 
   d="scan'208";a="612779791"
Message-ID: <4BC4D77A.1050208@linux.intel.com>
Date: Tue, 13 Apr 2010 13:43:38 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and	loose_nonint_oldconfig
References: <20100413194747.GX31193@redhat.com>
In-Reply-To: <20100413194747.GX31193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/2010 12:47, Aristeu Rozanski wrote:
> This patch has been around for a long time in Fedora and Red Hat Enterprise
> Linux kernels and it may be useful for others. The nonint_oldconfig target
> will fail and print the unset config options while loose_nonint_oldconfig will
> simply let the config option unset. They're useful in distro kernel packages
> where the config files are built using a combination of smaller config files.
> The patch's author AFAIK is Arjan van de Ven. Arjan, please add a Signed-off-by
> if you're the original author.
>
> Signed-off-by: Aristeu Rozanski<aris@redhat.com>


this gets funny with employers chaning etc ;)


Signed-off-by: Arjan van de Ven <arjan@redhat.com> [defunct email]
Acked-by: Arjan van de Ven <arjan@linux.intel.com>


