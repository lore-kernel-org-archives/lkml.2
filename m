Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab1LWQON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:14:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:61169 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1LWQOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:14:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90909263"
Subject: Re: [PATCH v2 08/19] dma: MX3_IPU fix depends
From: Vinod Koul <vinod.koul@intel.com>
To: Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <4EF4A696.9010509@eukrea.com>
References: <CAOMZO5AOpFtkJDmTSjPmvPVr0ra4d7jUcihGgncYE2VtfKCeSQ@mail.gmail.com>
	 <1323785575-22703-1-git-send-email-eric@eukrea.com>
	 <1324655127.1633.4.camel@vkoul-udesk3>  <4EF4A696.9010509@eukrea.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 21:44:13 +0530
Message-ID: <1324656853.1633.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-23 at 17:04 +0100, Eric Bénard wrote:
> if I followed everything (see Stephen Rothwell mail titled
> "linux-next: manual 
> merge of the slave-dma tree with the arm-soc tree"), this patch was
> not 
> applieed because the problem was already fixed in commit 8e2d41f8c856
> ("dma 
> i.MX: remove individual SOC dependency") from the slave-dma tree
> 
Okay thanks,
I will check the merge conflict

-- 
~Vinod

