Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab0DGKGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:06:34 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:29485
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab0DGKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:06:28 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzzz32i87h2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0I41G-02-1QV-02
X-M-MSG: 
Date: Wed, 7 Apr 2010 12:05:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: nhorman@tuxdriver.com, nhorman@redhat.com, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com,
       iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] AMD IOMMU kdump fix plus cleanups (v2)
Message-ID: <20100407100538.GK28166@amd.com>
References: <20100403012751.834020949@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100403012751.834020949@sous-sol.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Apr 2010 10:05:38.0908 (UTC) FILETIME=[DFC351C0:01CAD639]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 06:27:51PM -0700, Chris Wright wrote:
> Series includes the following patches:
> 
>   x86/amd-iommu: enable iommu before attaching devices
>   x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
>   Revert "x86: disable IOMMUs on kernel crash"
>   x86/amd-iommu: use for_each_pci_dev
> 
> First one is the primary bug fix.
> 
> v2
> - add disable_iommus on failure path
> - move removal of CMD_BUFFER_UNINITIALIZED to iommu_enable_command_buffer()
> - fix ";;" typo in patch 2
> - add Revert "x86: disable IOMMUs on kernel crash"
> - add x86/amd-iommu: use for_each_pci_dev

Applied all, thanks.

