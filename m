Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab1GOAbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:31:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:46482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab1GOAbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,531,1304319600"; 
   d="scan'208";a="26055814"
Message-ID: <4E1F8A44.8080609@intel.com>
Date: Fri, 15 Jul 2011 08:31:00 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 08/17] ACPI, APEI, GHES, Support disable GHES at boot
 time
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com> <1310534068-30547-9-git-send-email-ying.huang@intel.com> <20110714144716.GA3080@redhat.com>
In-Reply-To: <20110714144716.GA3080@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 10:47 PM, Don Zickus wrote:
> On Wed, Jul 13, 2011 at 01:14:19PM +0800, Huang Ying wrote:
>> Some machine may have broken firmware so that GHES and firmware first
>> mode should be disabled.  This patch adds support to that.
> 
> Does this still work if you have disabled ghes module support in the
> previous patch?

Yes.  Module param can be specified in kernel command line, for example
"ghes.disable=y".

Best Regards,
Huang Ying
