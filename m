Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0DDHaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:30:07 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:40228 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0DDHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:30:01 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Apr 2010 03:30:01 EDT
Message-ID: <4BB83EAE.5090609@bwalle.de>
Date: Sun, 04 Apr 2010 09:24:30 +0200
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Joerg Roedel <joro@8bytes.org>, nhorman@redhat.com, nhorman@tuxdriver.com,
       Joerg Roedel <joerg.roedel@amd.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>	<20100403012820.229410717@sous-sol.org>	<20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdc8juju.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bernhard@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.04.10 19:49, schrieb Eric W. Biederman:
> Not a problem.  We require a lot of things of the kdump kernel,
> and it is immediately apparent in a basic sanity test.

Also, in most cases (for example: distribution kernels), the kdump
kernel nowadays is identical to the running kernel. So, if the running
kernel has IOMMU support, the kdump kernel also has.


Regards,
Bernhard
