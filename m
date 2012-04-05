Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2DEMl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:41:57 -0400
Received: from apfelkorn.psychaos.be ([195.144.77.38]:44575 "EHLO
	apfelkorn.psychaos.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2DEMlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:41:55 -0400
X-Greylist: delayed 2386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 08:41:55 EDT
Date: Thu, 5 Apr 2012 15:03:53 +0300
From: "Peter 'p2' De Schrijver" <p2@debian.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
Message-ID: <20120405120352.GL6489@apfelkorn>
References: <1333625136-22630-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333625136-22630-1-git-send-email-pdeschrijver@nvidia.com>
X-Unexpected-Header: The spanish inquisition !
X-mate: Mate, mann gewohnt sich an alles
X-Paddo: Munch, Munch
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-05 14:25:23 (+0300), Peter De Schrijver <pdeschrijver@nvidia.com> wrote:
> On some systems (eg Tegra30) latencies for a given C state are not equal for
> all CPUs. Therefore we introduce a new per CPU structure which contains
> those parameters.

Sorry for sending this several times.

Cheers,

Peter.
