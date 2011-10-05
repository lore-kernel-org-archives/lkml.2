Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763Ab1JENZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934700Ab1JENZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:25:42 -0400
Message-ID: <4E8C5ACF.2000102@redhat.com>
Date: Wed, 05 Oct 2011 15:25:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20110923115119.GA29561@amt.cnet>
In-Reply-To: <20110923115119.GA29561@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 02:51 PM, Marcelo Tosatti wrote:
> On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
> >  This patchset is against https://github.com/avikivity/kvm.git next branch.
> >
> >  In this version, some changes come from Avi's comments:
> >  - fix instruction retried for nested guest
> >  - skip write-flooding for the sp whose level is 1
> >  - rename some functions
>
> Looks good to me.
>

To me as well.

-- 
error compiling committee.c: too many arguments to function

