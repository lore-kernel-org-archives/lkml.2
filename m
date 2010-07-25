Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0GYIsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0GYIsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:48:38 -0400
Message-ID: <4C4BFA63.5070102@redhat.com>
Date: Sun, 25 Jul 2010 11:48:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix hugepage mapping corrupt caused by regression
References: <4C492597.2000802@cn.fujitsu.com>
In-Reply-To: <4C492597.2000802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/23/2010 08:16 AM, Xiao Guangrong wrote:
> This is the regression, the bug which is fixed by commit e09e90a5
> is active now
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

