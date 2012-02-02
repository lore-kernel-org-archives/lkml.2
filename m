Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab2BBWaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:30:35 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33323 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933144Ab2BBWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:30:33 -0500
Message-ID: <4F2B1C1B.1040700@xenotime.net>
Date: Thu, 02 Feb 2012 15:28:27 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 2 (kvmtool)
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
In-Reply-To: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120201:


On some randconfig i386 builds, I am seeing this:

warning: (KVMTOOL_TEST_ENABLE && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)

because ARCH_SUPPORTS_MSI needs both X86_LOCAL_APIC and X86_IO_APIC
but configs don't necessarily have both of them enabled.

Do you want to add more selects here?
(this mess could continue for quite some time with other kconfig symbols)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
