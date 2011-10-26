Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1JZBPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:15:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42811 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754294Ab1JZBPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:15:08 -0400
Message-ID: <1319591707.16994.4.camel@Joe-Laptop>
Subject: Re: [PATCH] arm/tegra: clk_get should not be fatal
From: Joe Perches <joe@perches.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 25 Oct 2011 18:15:07 -0700
In-Reply-To: <20111025170038.GT1001@tbergstrom-lnx.Nvidia.com>
References: <1319559329-324-1-git-send-email-pdeschrijver@nvidia.com>
	 <1319559968.14932.5.camel@Joe-Laptop>
	 <20111025170038.GT1001@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 20:00 +0300, Peter De Schrijver wrote:
> Is pr_warn any different then pr_warning?

Other than being 3 characters shorter to type and it also
lets some format strings fit sub 80 chars line length?  No.

It is more like dev_warn, netdev_warn, et al.

cheers, Joe

