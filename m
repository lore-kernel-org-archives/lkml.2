Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1ADI4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:56:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:8745 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1ADI4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:56:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,271,1291622400"; 
   d="scan'208";a="369758235"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
Date: Tue, 4 Jan 2011 16:57:35 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <4D10E0C2.3020000@goop.org> <4D10EED0.2030507@redhat.com>
In-Reply-To: <4D10EED0.2030507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101041657.36123.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 December 2010 02:15:44 Avi Kivity wrote:
> On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
> > On 12/20/2010 10:18 PM, Sheng Yang wrote:
> > >  Then we can reuse it for Xen later.
> > 
> > You should probably get someone kvm-ish to ack this too.
> 
> Looks good to me.

Ingo,

Comments?

--
regards
Yang, Sheng
