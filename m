Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1IMS1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:27:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60266 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1IMS1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:27:14 -0400
Message-ID: <4E6FA117.1050707@cn.fujitsu.com>
Date: Wed, 14 Sep 2011 02:29:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/11] KVM: MMU: do not mark accessed bit on pte write
 path
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C8D.5040509@cn.fujitsu.com> <4E6F363E.9080000@redhat.com>
In-Reply-To: <4E6F363E.9080000@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 02:26:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 02:26:00,
	Serialize complete at 2011-09-14 02:26:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 06:53 PM, Avi Kivity wrote:
> On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
>> In current code, the accessed bit is always set when page fault occurred,
>> do not need to set it on pte write path
> 
> What about speculative sptes that are then only accessed via emulation?
> 

The gfn is read and written only via emulation? I think this case is very
very rare?
