Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2DKKVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:21:51 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59115
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab2DKKVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:21:49 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2B8S5-01-20B-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 12:21:37 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: <avi@redhat.com>, <mtosatti@redhat.com>, <ebiederm@xmission.com>,
        <luto@mit.edu>, <dzickus@redhat.com>, <paul.gortmaker@windriver.com>,
        <gregkh@suse.de>, <ludwig.nussel@suse.de>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
Message-ID: <20120411102136.GG2428@amd.com>
References: <4F84E0DF.8040206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F84E0DF.8040206@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 11, 2012 at 09:39:43AM +0800, zhangyanfei wrote:
> The problem is that VMCS internal is hidden by Intel in its
> specification. So, we reverse engineering it in the way implemented in
> this patch set.

Have you made sure this layout is the same on all uarchitectures that
implment VMX?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

