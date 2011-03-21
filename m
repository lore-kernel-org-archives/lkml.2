Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1CUXbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:31:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:51835 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178Ab1CUXbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,222,1299484800"; 
   d="scan'208";a="615901733"
Date: Mon, 21 Mar 2011 16:31:04 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: Hot plug issue on 2.6.38
Message-ID: <20110321233104.GA4334@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <201103170119.17647.rjw@sisk.pl>
 <AANLkTim39fjrAp4OW_MfpbZkz-YYW5E2NOHuo1j=svmW@mail.gmail.com>
 <201103172222.33336.rjw@sisk.pl>
 <20110317215609.GA5917@xanatos>
 <20110321222705.GA4139@xanatos>
 <20110321223408.GA17412@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321223408.GA17412@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 10:34:08PM +0000, Matthew Garrett wrote:
> Try setting CONFIG_HOTPLUG_PCI_ACPI to y as well, just to rule that out?

It's set to build as a module, do you want me to compile it in?

Sarah Sharp
