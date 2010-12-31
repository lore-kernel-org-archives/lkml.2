Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0LaCHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 21:07:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:3071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab0LaCHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 21:07:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,252,1291622400"; 
   d="scan'208";a="368290417"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
Date: Fri, 31 Dec 2010 10:05:43 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <4D10E0C2.3020000@goop.org> <4D10EED0.2030507@redhat.com>
In-Reply-To: <4D10EED0.2030507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311005.44001.sheng@linux.intel.com>
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

Ingo/Peter?

--
regards
Yang, Sheng
