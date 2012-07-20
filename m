Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2GTSAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:00:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54214 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2GTSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:00:09 -0400
Date: Fri, 20 Jul 2012 11:00:08 -0700 (PDT)
Message-Id: <20120720.110008.475112724617192181.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jdmason@kudzu.us, trivial@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com
Subject: Re: [trivial PATCH resend 1/2] ixgb: use PCI_VENDOR_ID_INTEL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342768277.2616.22.camel@jtkirshe-mobl>
References: <1342767729-17788-1-git-send-email-jdmason@kudzu.us>
	<1342767729-17788-2-git-send-email-jdmason@kudzu.us>
	<1342768277.2616.22.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 20 Jul 2012 00:11:17 -0700

> On Fri, 2012-07-20 at 00:02 -0700, Jon Mason wrote:
>> Use PCI_VENDOR_ID_INTEL from pci_ids.h instead of creating its own
>> vendor ID #define.
>> 
>> Signed-off-by: Jon Mason <jdmason@kudzu.us>
 ...
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
