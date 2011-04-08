Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1DHP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:26:12 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:35574 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932274Ab1DHP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:26:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MleTVNdcL3cz4PZB5GrRpQ+3KeiYo8+1ksXYnoOYQ5NivT6HK35t1sqQBIZTMv1iTDW+EkR4Pv1NuNRdObv1vZvAmKAWdhgYbHF8omMoe3UC+qmSvjyLqOxZ9gcM1kfP;
Date: Fri, 8 Apr 2011 08:25:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/5] PCI: Move ATS declarations in seperate header file
Message-ID: <20110408082559.43adcbed@jbarnes-desktop>
In-Reply-To: <1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
	<1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011 10:17:06 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch moves the relevant declarations from the local
> header file in drivers/pci to a more accessible locations so
> that it can be used by the AMD IOMMU driver too.
> The file is named pci-ats-pri.h because support for the PCI
> PRI capability will also be added there in a later
> patch-set.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/pci/intel-iommu.c |    1 +
>  drivers/pci/iov.c         |    1 +
>  drivers/pci/pci.h         |   37 --------------------------------
>  include/linux/pci-ats.h   |   52 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 37 deletions(-)
>  create mode 100644 include/linux/pci-ats.h

Looks fine.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
