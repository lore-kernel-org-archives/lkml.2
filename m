Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab2CTOnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760344Ab2CTOnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:43:05 -0400
Message-ID: <4F689775.6060302@redhat.com>
Date: Tue, 20 Mar 2012 16:43:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: srcu-less dirty logging -v2
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 12:30 PM, Takuya Yoshikawa wrote:
> This patch series is the result of the integration of my dirty logging
> optimization work, including preparation for the new GET_DIRTY_LOG API,
> and the attempt to get rid of controversial synchronize_srcu_expedited().
>
> 1 - KVM: MMU: Split the main body of rmap_write_protect() off from others
> 2 - KVM: Avoid checking huge page mappings in get_dirty_log()
> 3 - KVM: Switch to srcu-less get_dirty_log()
> 4 - KVM: Remove unused dirty_bitmap_head and nr_dirty_pages
>
> Although there are still some remaining tasks, the test result obtained
> looks very promising.
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

