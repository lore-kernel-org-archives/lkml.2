Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab0HCXYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:24:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab0HCXYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:24:23 -0400
Message-ID: <4C58A4E7.4030800@zytor.com>
Date: Tue, 03 Aug 2010 16:23:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org, michaelc@cs.wisc.edu,
        mcb30@ipxe.org
Subject: Re: [GIT PULL] iBFT features for v2.6.36
References: <20100802143642.GA15428@hera.kernel.org> <20100802195248.GB32503@andromeda.dapyr.net> <4C572A13.4010303@zytor.com> <201008022108.04024.konrad@kernel.org> <4C577EFA.4070003@zytor.com> <4C582918.5080602@redhat.com>
In-Reply-To: <4C582918.5080602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 07:35 AM, Peter Jones wrote:
> 
> The current iBFT specification and the current code (this push) includes the
> ability to specify the location of the iBFT table using the standard ACPI table
> mechanism, which is required on UEFI machines supporting iBFT, and which I
> would encourage non-UEFI machines to also use where possible.  Obviously some
> systems, especially BIOS-based machines doing iSCSI boot on expansion cards,
> have difficulty with this, so we're not planning on de-supporting the old
> memory scanning method.
> 

Not just expansion cards, but also post-INT19 software solutions.

	-hpa
