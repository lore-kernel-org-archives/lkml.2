Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0DZDOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 23:14:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62008 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab0DZDOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 23:14:32 -0400
Message-ID: <4BD5045D.2040806@cn.fujitsu.com>
Date: Mon, 26 Apr 2010 11:11:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/10] KVM MMU: split kvm_sync_page() function
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E89C.8090307@cn.fujitsu.com> <4BD41063.9010704@redhat.com>
In-Reply-To: <4BD41063.9010704@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
    
> 
> This isn't a split; it duplicates the code.
> 
> Since there are some parts in the middle of kvm_sync_page() you don't
> want in sync_page_transient(), you can put them into helpers so that
> sync_page and sync_page_transient only call helpers.
> 

Will fix it in v3, thanks
