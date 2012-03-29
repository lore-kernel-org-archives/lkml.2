Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab2C2VCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:02:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44352 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223Ab2C2VCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:02:39 -0400
Date: Thu, 29 Mar 2012 16:02:33 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
Message-ID: <20120329210233.GD18784@burratino>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
 <20120329163206.GA3480@burratino>
 <20120329134614.438e8aaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329134614.438e8aaf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Jonathan Nieder <jrnieder@gmail.com> wrote:

>> From: Matthew Garrett <mjg@redhat.com>
>> Date: Tue, 27 Mar 2012 10:17:41 -0400
[...]
>>            commit 4949be16822e ("PCI: ignore pre-1.1 ASPM quirking
>> when ASPM is disabled") changed the behaviour of
>> pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in
>> order to avoid cases where we changed ASPM state on pre-PCIe 1.1
>> devices.  This skipped the secondary function of
>> pcie_aspm_sanity_check which was to avoid us enabling ASPM on devices
>> that had non-PCIe children, causing trouble later on.
[...]
>>                                                               Could
>> you pick it up for linux-next until it makes its way to the PCI tree?
[...]
> Just about the only person who wasn't copied on this email is, umm, the
> PCI maintainer!

Well spotted.  Thanks for catching it.
