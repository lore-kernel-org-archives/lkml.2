Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1LSLAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:00:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:41817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1LSLAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:00:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89006374"
Date: Mon, 19 Dec 2011 12:04:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        Denis Turischev <denis@compulab.co.il>, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Mocean Laboratories <info@mocean-labs.com>,
        Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] mfd: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111219110445.GA11800@sortiz-mobl>
References: <1322703663.11560.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322703663.11560.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Dec 01, 2011 at 09:41:03AM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
Looks good, I applied it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
