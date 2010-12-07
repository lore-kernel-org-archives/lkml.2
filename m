Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0LGJw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:52:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0LGJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:52:27 -0500
Message-ID: <4CFE03D3.3080507@redhat.com>
Date: Tue, 07 Dec 2010 11:52:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] KVM: MMU: rename 'no_apf' to 'prefault'
References: <4CFD9D12.30709@cn.fujitsu.com>
In-Reply-To: <4CFD9D12.30709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 04:33 AM, Xiao Guangrong wrote:
> It's the speculative path if 'no_apf = 1' and we will specially handle this
> speculative path in the later patch, so 'prefault' is better to fit the sense

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

