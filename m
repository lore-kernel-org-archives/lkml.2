Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0CQKPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:15:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab0CQKPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:15:12 -0400
Message-ID: <4BA0AB36.40204@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 18:13:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] KVM: cleanup {kvm_vm_ioctl, kvm}_get_dirty_log()
References: <4BA0897F.3050906@cn.fujitsu.com> <4BA09023.4000706@oss.ntt.co.jp> <4BA092AE.3090206@cn.fujitsu.com> <4BA095B9.3010109@oss.ntt.co.jp>
In-Reply-To: <4BA095B9.3010109@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Takuya Yoshikawa wrote:

> 
> Ah, probably checking the git log will explain you why it is like that!
> Marcelo's work? IIRC.

Oh, i find this commit:

commit 706831a7faec7ac0d3057d20df8234c45bbbc3c5
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Wed Dec 23 14:35:22 2009 -0200

    KVM: use SRCU for dirty log
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

But i don't know why Marcelo separates kvm_get_dirty_log()'s code
into kvm_vm_ioctl_get_dirty_log(). :-(

Thanks,
Xiao

