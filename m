Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0DDHve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:51:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52505 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab0DDHv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:51:28 -0400
To: Bernhard Walle <bernhard@bwalle.de>
Cc: Joerg Roedel <joro@8bytes.org>, nhorman@redhat.com, nhorman@tuxdriver.com,
       Joerg Roedel <joerg.roedel@amd.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org>
	<4BB83EAE.5090609@bwalle.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Apr 2010 00:51:10 -0700
In-Reply-To: <4BB83EAE.5090609@bwalle.de> (Bernhard Walle's message of "Sun\, 04 Apr 2010 09\:24\:30 +0200")
Message-ID: <m1pr2fhd01.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: bernhard@bwalle.de, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, joerg.roedel@amd.com, nhorman@tuxdriver.com, nhorman@redhat.com, joro@8bytes.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bernhard@bwalle.de> writes:

> Am 03.04.10 19:49, schrieb Eric W. Biederman:
>> Not a problem.  We require a lot of things of the kdump kernel,
>> and it is immediately apparent in a basic sanity test.
>
> Also, in most cases (for example: distribution kernels), the kdump
> kernel nowadays is identical to the running kernel. So, if the running
> kernel has IOMMU support, the kdump kernel also has.

I have been rather pleasantly surprised at how well that works.  Although
I am still glad I insisted that using the same kernel version not be a
hard requirement.  It allowed us to specify a good solid interface.

How to cope with GART in that situation without having to manually specify
iommu=off in the configuration I find a more compelling question.

I expect I will have a look at that in the coming months if someone doesn't get
there before I do.

Eric
