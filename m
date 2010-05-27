Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0E0QCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab0E0QCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:02:51 -0400
Date: Thu, 27 May 2010 13:02:48 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
Message-ID: <20100527160248.GF3445@mothafucka.localdomain>
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
 <4BFE2A2F.50209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFE2A2F.50209@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:15:43AM +0300, Avi Kivity wrote:
> On 05/26/2010 09:04 PM, Glauber Costa wrote:
> >This patch adds a file that documents the usage of KVM-specific
> >MSRs.
> >
> 
> Looks good.  A few comments:
> 
> >+
> >+Custom MSR list
> >+--------
> >+
> >+The current supported Custom MSR list is:
> >+
> >+MSR_KVM_WALL_CLOCK:  0x11
> >+
> >+	data: physical address of a memory area.
> 
> Which must be in guest RAM (i.e., don't point it somewhere random
> and expect the hypervisor to allocate it for you).
> 
> Must be aligned to 4 bytes (we don't enforce it though).
I don't see the reason for it.

If this is a requirement, our own implementation
is failing to meet it.


