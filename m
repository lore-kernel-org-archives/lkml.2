Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab1JaP1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:27:40 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:49074 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab1JaP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:27:39 -0400
Message-ID: <4EAEBE69.9080806@tilera.com>
Date: Mon, 31 Oct 2011 11:27:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <vapier@gentoo.org>, <dhowells@redhat.com>,
        <ysato@users.sourceforge.jp>, <tony.luck@intel.com>,
        <fenghua.yu@intel.com>, <monstr@monstr.eu>, <ralf@linux-mips.org>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <lethal@linux-sh.org>,
        <davem@davemloft.net>, <gxt@mprc.pku.edu.cn>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <chris@zankel.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 07/16] PCI: TILE: convert pcibios_set_master() to
 a non-inlined function
References: <20111028214726.20088.30551.stgit@amt.stowe> <20111028214817.20088.15009.stgit@amt.stowe>
In-Reply-To: <20111028214817.20088.15009.stgit@amt.stowe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 5:48 PM, Myron Stowe wrote:
> From: Myron Stowe <mstowe@redhat.com>
>
> This patch converts TILE's architecture-specific 'pcibios_set_master()'
> routine to a non-inlined function.  This will allow follow on patches
> to create a generic 'pcibios_set_master()' function using the '__weak'
> attribute which can be used by all architectures as a default which,
> if necessary, can then be over-ridden by architecture-specific code.
>
> Converting 'pci_bios_set_master()' to a non-inlined function will
> allow TILE's 'pcibios_set_master()' implementation to remain
> architecture-specific after the generic version is introduced and
> thus, not change current behavior.
>
> No functional change.
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

