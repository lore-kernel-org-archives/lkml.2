Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966369Ab2EPJV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010Ab2EPJV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:21:57 -0400
Message-ID: <4FB371B1.7000407@redhat.com>
Date: Wed, 16 May 2012 12:21:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: Re: [PATCH 0/4] KVM: Enable EPT access bit feature
References: <20120516010439.GA14256@hp-xd.sh.intel.com>
In-Reply-To: <20120516010439.GA14256@hp-xd.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 04:04 AM, Xudong Hao wrote:
> EPT A/D bits enable VMMs to efficiently implement memory management and page classification algorithms to optimize VM memory operations such as de-fragmentation, paging, live-migration, and check-pointing.
>
> The series of patches enable the EPT access bit in KVM.
>
> PATCH 1: Add EPT A/D bits definition.
> PATCH 2: Add kernel parameter to control EPT A/D bits support, the feature is on by default.
> PATCH 3: Enable EPT A/D bits if supported by turning on relevant bit in EPTP.
> PATCH 4: Enabling Access bit when doing memory swapping.
>

Minor comment on patch 2, but otherwise looks good.

-- 
error compiling committee.c: too many arguments to function

