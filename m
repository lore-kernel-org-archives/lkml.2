Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0HQJEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab0HQJEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:04:11 -0400
Message-ID: <4C6A5086.403@redhat.com>
Date: Tue, 17 Aug 2010 12:04:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: unlisted-recipients:"; Marcelo Tosatti" <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Marcelo Tosatti <mtosatti@redhat.com>
					     ^-missing end of address
Subject: Re: [PATCH RESEND] KVM: PIT: free irq source id in handling error
 path
References: <4C454196.70500@cn.fujitsu.com> <4C6A33F4.2080201@cn.fujitsu.com>
In-Reply-To: <4C6A33F4.2080201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/17/2010 10:02 AM, Xiao Guangrong wrote:
> Free irq source id if create pit workqueue fail
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

