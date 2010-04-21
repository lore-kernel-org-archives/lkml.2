Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0DUIW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab0DUIW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:22:28 -0400
Message-ID: <4BCEB5B4.3080502@redhat.com>
Date: Wed, 21 Apr 2010 11:22:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: use the correct RCU API
References: <4BCC2543.7050104@cn.fujitsu.com>
In-Reply-To: <4BCC2543.7050104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:41 PM, Lai Jiangshan wrote:
> The RCU/SRCU API have already changed for proving RCU usage.
>
> I got the following dmesg when PROVE_RCU=y because we used incorrect API.
> This patch coverts rcu_deference() to srcu_dereference() or family API.
>    


Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

