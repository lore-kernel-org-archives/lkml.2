Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab1FASuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:50:00 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:53623 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752532Ab1FASt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:49:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=g9D0kVRhAKfA6jIYmq/aeHreS+XG+Yw0E/Koa1TluA6AK0rpB2mCUIAQMsk81zS2f9SVuP+MwmJ6VVk1GqKMP+jpP6znPGA4oOZBxnkRZkBjSCGwrUIiQAgrssg32HtU;
Date: Wed, 1 Jun 2011 11:49:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH 7/9] PCIe, AER, add aer_recover_queue
Message-ID: <20110601114937.69d69916@jbarnes-desktop>
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

Have the dependencies for this already landed?  Or does this one need
to go first?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
