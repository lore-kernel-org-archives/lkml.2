Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2DTFhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 01:37:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:12654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2DTFhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 01:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="91200200"
Subject: Re: [PATCH v2] ACPI: D3 states cleanup
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb <lenb@kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20120420052259.GA21040@localhost.amd.com>
References: <1334884749.4927.6.camel@minggr>
	 <20120420022304.GA3001@localhost.amd.com> <1334891953.4927.19.camel@minggr>
	 <20120420052259.GA21040@localhost.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 13:37:35 +0800
Message-ID: <1334900255.4927.36.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 13:23 +0800, Aaron Lu wrote:
> On Fri, Apr 20, 2012 at 11:19:13AM +0800, Lin Ming wrote:
> > On Fri, 2012-04-20 at 10:23 +0800, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Fri, Apr 20, 2012 at 09:19:09AM +0800, Lin Ming wrote:
> > > > There are two ACPI D3 states defined now:
> > > > ACPI_STATE_D3 and ACPI_STATE_D3_COLD.
> > > > 
> > > > But the uses of these states are not clear/correct in some code.
> > > > For example, some code refer ACPI_STATE_D3 as D3hot and others refer
> > > > it as D3cold.
> > > > 
> > > > This patch introduces ACPI_STATE_D3_HOT to refer to ACPI D3hot state.
> > > > And changes ACPI_STATE_D3 to refer to ACPI D3cold state only.
> > > > Also redefines ACPI_STATE_D3_COLD the same as ACPI_STATE_D3.
> > > > 
> > > 
> > > With this patch now, if a device has _PS3, then we will set its D3hot
> > > flag valid. This doesn't feel right to me, since per our discussion the
> > > other day, we should assume _PS3 will put the device into D3cold.
> > > 
> > > Or do you mean: if _PS3 is available, then both D3hot and D3cold is
> > > valid from the perspective of acpi, it is the individual driver's
> > > responsibility to decide which state is actually valid and will be used.
> > 
> > Right.
> > 
> > ACPI_STATE_D3(same as ACPI_STATE_D3_COLD now) is always valid.
> > 
> 
> I mean, if _PS3 is available, can we say D3hot is valid?

Yes.

Lin Ming

