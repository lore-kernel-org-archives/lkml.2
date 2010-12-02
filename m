Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0LBDkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:40:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0LBDkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:40:03 -0500
Message-ID: <4CF71616.6020302@cn.fujitsu.com>
Date: Thu, 02 Dec 2010 11:44:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: MMU: retry #PF for softmmu
References: <4CF4C535.8080405@cn.fujitsu.com> <4CF4C5E0.2020301@cn.fujitsu.com> <20101202011942.GA24787@amt.cnet>
In-Reply-To: <20101202011942.GA24787@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-02 11:40:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-02 11:40:11,
	Serialize complete at 2010-12-02 11:40:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 09:19 AM, Marcelo Tosatti wrote:
> On Tue, Nov 30, 2010 at 05:37:36PM +0800, Xiao Guangrong wrote:

> 
> Can't you just compare cr3 value? Its harmless to instantiate an spte
> for an unused translation.
> 

It may retry #PF in different mmu context, but i think it's acceptable.
Will update it in next version. Thanks, Marcelo!
