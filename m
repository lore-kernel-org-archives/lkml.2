Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1LWNfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:35:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab1LWNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:35:08 -0500
Subject: Re: [PATCH] arch/powerpc/kvm/e500: Additional module.h => export.h fixup
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1324570863-11447-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Fri, 23 Dec 2011 14:35:06 +0100
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, KVM list <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>
Content-Transfer-Encoding: 7bit
Message-Id: <26A61517-48D0-45D4-B3A3-D6C51FC1F91A@suse.de>
References: <1324570863-11447-1-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.12.2011, at 17:21, Kyle Moffett wrote:

> This file, like many others, needs to include <linux/export.h>.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

Thanks, I already applied a patch from Scott that addresses the same issue.


Alex

