Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab1JELy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 07:54:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:14223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab1JELy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 07:54:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60110239"
Subject: Re: kmemleaks related to ACPI psparse
From: Lin Ming <ming.m.lin@intel.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111004063720.GA13579@sucs.org>
References: <20110916072210.GA25500@sucs.org>
	 <1316158194.5362.5.camel@minggr> <20110916090236.GA27803@sucs.org>
	 <20111004063720.GA13579@sucs.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 05 Oct 2011 19:54:39 +0800
Message-ID: <1317815679.3658.10.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 14:37 +0800, Sitsofe Wheeler wrote:
> Hi,
> 
> On Fri, Sep 16, 2011 at 10:02:36AM +0100, Sitsofe Wheeler wrote:
> > 
> > On Fri, Sep 16, 2011 at 03:29:54PM +0800, Lin Ming wrote:
> > > On Fri, 2011-09-16 at 15:22 +0800, Sitsofe Wheeler wrote:
> > > > 
> > > > In 3.1.0-rc5-dirty the following warning appeared in dmesg:
> > > 
> > > Please attach the acpidump output.
> > 
> > My EeePC 900's acpidump output should be attached as a gz. 
> 
> This issue hasn't happened since - is it worth ignoring this for now?

Yes.

Thanks for test.

