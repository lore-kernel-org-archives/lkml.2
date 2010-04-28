Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0D1ROP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:14:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0D1RON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:14:13 -0400
Date: Wed, 28 Apr 2010 14:12:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/10] KVM MMU: allow more shadow pages become
 asynchronous
Message-ID: <20100428171237.GF18168@amt.cnet>
References: <4BD7B177.9020003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD7B177.9020003@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:54:31AM +0800, Xiao Guangrong wrote:
> Changlog v3:
> 
> Those changes all form Avi's suggestion, thanks.
> 
> - use smart way to fix the bug in patch 1
> - remove duplicates code in patch 5
> - check error code and fix forgot release page in patch 9
> - sync shadow pages in a batch instead of one by one
> 
> And, there is one TODO thing:
> Marker shadow page as unsync at create time avoid write-protect,
> this idea is from Avi:
> 
> |Another interesting case is to create new shadow pages in the unsync state.
> |That can help when the guest starts a short lived process: we can avoid write
> |protecting its pagetables completely
> 
> I'll send the patch out after this patchset applied.
>  
> Changlog v2:
> 
> - when level is PT_DIRECTORY_LEVEL, the 'offset' should be
>   'role.quadrant << 8', thanks Avi for point it out
> 
> - keep invlpg code in paging_tmpl.h address Avi's suggestion
> 
> - split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
>   to clarify the code address Avi's suggestion

Applied, thanks.

