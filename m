Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1AEBtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:49:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:53123 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1AEBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,275,1291622400"; 
   d="scan'208";a="370167672"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
Date: Wed, 5 Jan 2011 09:51:59 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101041657.36123.sheng@linux.intel.com> <20110104092418.GA31281@elte.hu>
In-Reply-To: <20110104092418.GA31281@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101050952.00104.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 January 2011 17:24:18 Ingo Molnar wrote:
> * Sheng Yang <sheng@linux.intel.com> wrote:
> > On Wednesday 22 December 2010 02:15:44 Avi Kivity wrote:
> > > On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
> > > > On 12/20/2010 10:18 PM, Sheng Yang wrote:
> > > > >  Then we can reuse it for Xen later.
> > > > 
> > > > You should probably get someone kvm-ish to ack this too.
> > > 
> > > Looks good to me.
> > 
> > Ingo,
> > 
> > Comments?
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> I suspect these patches want to be carried in the Xen tree, right? Shouldnt
> cause too bad conflicts, as long as the Xen tree is pushed after the x86
> tree in the merge window.

Jeremy?

--
regards
Yang, Sheng

> 
> Thanks,
> 
> 	Ingo
