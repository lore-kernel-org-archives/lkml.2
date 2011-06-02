Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1FBPMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:12:43 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.55]:46330 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752130Ab1FBPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:12:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nwxkWTj2rX/ZENjh0UcpSOTrrxYno9VlU/W97hGiUgsQvSoh6b9oa+A5S3l6NnZuWnNoFNMWqkb9jbrKFbgKFp+ovyJ/aVKth0OKvxRifk1+QB+n5mp1aP4Uj3OcpYCq;
Date: Thu, 2 Jun 2011 08:05:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH 7/9] PCIe, AER, add aer_recover_queue
Message-ID: <20110602080539.52bb6d89@jbarnes-desktop>
In-Reply-To: <1305619719-7480-8-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
	<1305619719-7480-8-git-send-email-ying.huang@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 16:08:37 +0800
Huang Ying <ying.huang@intel.com> wrote:

> In addition to native PCIe AER, now APEI (ACPI Platform Error
> Interface) GHES (Generic Hardware Error Source) can be used to report
> PCIe AER errors too.  To add support to APEI GHES PCIe AER recovery,
> aer_recover_queue is added to export the recovery function in native
> PCIe AER driver.
> 
> Recoverable PCIe AER errors are reported via NMI in APEI GHES.  Then
> APEI GHES uses irq_work to delay the error processing into an IRQ
> handler.  But PCIe AER recovery can be very time-consuming, so
> aer_recover_queue, which can be used in IRQ handler, delays the real
> recovery action into the process context, that is, work queue.

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
