Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0LACQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:16:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52615 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0LACQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:16:11 -0500
Message-ID: <4CF5B0F6.8030900@cn.fujitsu.com>
Date: Wed, 01 Dec 2010 10:20:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
References: <4CF4C535.8080405@cn.fujitsu.com> <4CF4C587.7080000@cn.fujitsu.com> <20101130132915.GG2187@redhat.com> <4CF52BC6.9020401@cn.fujitsu.com> <20101130175005.GA2924@redhat.com> <4CF53F41.1040503@cn.fujitsu.com> <20101130183833.GB2924@redhat.com> <4CF54C4F.80901@cn.fujitsu.com> <20101130192059.GC2924@redhat.com>
In-Reply-To: <20101130192059.GC2924@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 10:16:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-01 10:16:20,
	Serialize complete at 2010-12-01 10:16:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 03:20 AM, Gleb Natapov wrote:

> Firs of all if guest is PV the guest process cannot be killed. Second
> why is it a problem that we marked pfn as accessed on speculative path?
> What problem it causes especially since it is very likely that the page
> will be accessed shortly anyway?
> 

Hi Avi, Marcelo,

What is your opinion on this point?
