Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab1JIMYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 08:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1JIMYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 08:24:20 -0400
Message-ID: <4E91926D.8060206@redhat.com>
Date: Sun, 09 Oct 2011 14:24:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com>
In-Reply-To: <4E8FCC37.8090409@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2011 06:06 AM, Xiao Guangrong wrote:
> On 10/07/2011 01:53 AM, Marcelo Tosatti wrote:
> >  On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
> >>  This patchset is against https://github.com/avikivity/kvm.git next branch.
> >>
> >>  In this version, some changes come from Avi's comments:
> >>  - fix instruction retried for nested guest
> >>  - skip write-flooding for the sp whose level is 1
> >>  - rename some functions
> >
> >  Please rebase.
> >
> >
>
> Marcelo,
>
> These patches can be applied without any conflict and it also works well,
> the current code was pulled from https://github.com/avikivity/kvm.git next branch.
>
> What problem did you meet when you applied these? :(

I guess it was a user error - it applies cleanly here too (and pushed to 
next, thanks).

-- 
error compiling committee.c: too many arguments to function

