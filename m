Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2HWVy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:54:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:43931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2HWVyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:54:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="209904620"
Message-ID: <5036A67D.9090904@linux.intel.com>
Date: Thu, 23 Aug 2012 14:54:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ShuoX Liu <shuox.liu@intel.com>, mjg59@srcf.ucam.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/3] c-state governor changes
References: <20120823171104.38574add@cuia.bos.redhat.com>
In-Reply-To: <20120823171104.38574add@cuia.bos.redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2012 2:11 PM, Rik van Riel wrote:
> This patch set is mostly there to kick off a discussion in time
> for Kernel Summit.  When running it on my laptop, with acpi_idle,
> I see a promising change in powertop.

be careful with acpi_idle... that will remove most of the intermediate C states the platform has,
so the policy engine no longer has good things to chose from.


