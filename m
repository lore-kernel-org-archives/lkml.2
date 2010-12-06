Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0LFUpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:45:14 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46019 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753655Ab0LFUpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:45:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BEAFsnmGFlVdNsOfwIZz1AzRQ62/qAQQp+CICrHk52WoJG2rc+W2yMbLz9i3m8HVd30+8gme1Ng3U5n9poFtPxiCLq3uLC/nuH3kDh/VQHB5il/fhyLwayrKy3+xxh1j;
Date: Mon, 6 Dec 2010 12:44:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch 1/4] vt-d: quirk for masking vtd spec errors to platform
 error handling logic
Message-ID: <20101206124423.0868b71e@jbarnes-desktop>
In-Reply-To: <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20101201062225.292364637@intel.com>
	<20101201062244.365995600@intel.com>
	<20101206092749.7f89f3fd@jbarnes-desktop>
	<1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Dec 2010 12:26:30 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2010-12-06 at 09:27 -0800, Jesse Barnes wrote:
> > Can we make these registers and bits a bit more self-documenting (i.e.
> > #defines for both, maybe along with other useful bit definitions for
> > this reg)? Also, "error" is misspelled as "erorr" above. :)
> 
> Thanks for the review. Appended the updated patch. I haven't used
> #defines for the pci-id's, as the first one (IOH) is used by several
> chipsets and the second one is not named yet.

Is there a bug # that should be referenced in the commit log?  Any
tested-bys to add?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
