Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1FVJwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:52:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:41207 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FVJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.65,405,1304294400"; 
   d="scan'208";a="6419717"
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>
In-Reply-To: <4E01B89C.7050704@redhat.com>
References: <4DF97D6C.2080900@redhat.com>  <4DFDEF2A.7050307@redhat.com>
	 <1308735302.6920.172.camel@zakaz.uk.xensource.com>
	 <4E01B89C.7050704@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Jun 2011 10:52:01 +0100
Message-ID: <1308736321.6920.174.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 10:40 +0100, Avi Kivity wrote:
> On 06/22/2011 12:35 PM, Ian Campbell wrote:
> > On Sun, 2011-06-19 at 15:44 +0300, Avi Kivity wrote:
> > >  On 06/16/2011 06:50 AM, Zachary Amsden wrote:
> > >  >  The 128-bit multiply in pvclock.h was missing an output constraint for
> > >  >  EDX which caused a register corruption to appear.
> >
> > Was there any particular symptom associated with corruption at that
> > particular point or just general badness?
> >
> 
> Time went backwards and forwards as vcpus were migrated across cpus.

Oops!

> The problem was in the host, not the guest, so Xen should not be affected.

Good to know, thanks!

Ian.

