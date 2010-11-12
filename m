Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0KLKdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:33:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0KLKdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:33:02 -0500
Message-ID: <4CDD18DE.6080902@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 18:37:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: MMU: rename 'reset_host_protection' to 'host_writeable'
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD17F3.2000704@cn.fujitsu.com>
In-Reply-To: <4CDD17F3.2000704@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:33:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:33:26,
	Serialize complete at 2010-11-12 18:33:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 06:33 PM, Xiao Guangrong wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Rename it to fix the sense better 
> 

CCed to Lai Jiangshan
