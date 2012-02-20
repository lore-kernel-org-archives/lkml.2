Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2BTFno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:43:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:43974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2BTFnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:43:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108524689"
Message-ID: <1329716631.1511.23.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 20 Feb 2012 13:43:51 +0800
In-Reply-To: <201202172334.04301.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202142336.28706.rjw@sisk.pl>
	 <1329376686.28581.15.camel@rui.sh.intel.com>
	 <201202172334.04301.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-02-17 at 23:34 +0100, Rafael J. Wysocki wrote:
> 
> > So I introduced these two APIs so that an runtime_resume request can be
> > sent to ZPODD directly and the runtime PM core can resume all the
> > parents of ZPODD automatically.
> 
> It seems that you're confusing things.  In the Linux driver model a device
> cannot have more than a single parent.
>
sorry, I mean the ancients here, e.g. scsi-host, etc. :)

thanks,
rui

