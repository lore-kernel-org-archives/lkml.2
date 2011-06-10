Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1FJDtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:49:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59990 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1FJDtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:49:17 -0400
Message-ID: <4DF194B5.1050104@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 11:51:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/15] KVM: x86: avoid unnecessarily guest page table
 walking
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20CA.90206@cn.fujitsu.com> <4DF06F5E.9070608@redhat.com>
In-Reply-To: <4DF06F5E.9070608@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:49:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:49:02,
	Serialize complete at 2011-06-10 11:49:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 02:59 PM, Avi Kivity wrote:

> This breaks is addr/bytes spans a page boundary.
> 
> (the current code is also broken, but only for mmio; the new code is broken for ram as well).
> 
> We need a gva_to_gpa() that returns a range of pages.
> 

Thanks for you point it out, will fix it in the next version.
