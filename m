Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab1I3Dq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:46:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab1I3Dq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:46:56 -0400
Message-ID: <4E853C34.10106@cn.fujitsu.com>
Date: Fri, 30 Sep 2011 11:49:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20110923115119.GA29561@amt.cnet>
In-Reply-To: <20110923115119.GA29561@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-30 11:45:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-30 11:45:22,
	Serialize complete at 2011-09-30 11:45:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 07:51 PM, Marcelo Tosatti wrote:
> On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
>> This patchset is against https://github.com/avikivity/kvm.git next branch.
>>
>> In this version, some changes come from Avi's comments:
>> - fix instruction retried for nested guest
>> - skip write-flooding for the sp whose level is 1
>> - rename some functions
> 
> Looks good to me.
> 

Ping......

