Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1CDJI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:08:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759285Ab1CDJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:08:57 -0500
Message-ID: <4D70AC1D.4080705@redhat.com>
Date: Fri, 04 Mar 2011 17:08:45 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, fubar@us.ibm.com, netdev@vger.kernel.org
Subject: Re: [Patch] bonding: move procfs into bond_procfs.c
References: <1298896204-6521-1-git-send-email-amwang@redhat.com> <20110302.221707.260068518.davem@davemloft.net>
In-Reply-To: <20110302.221707.260068518.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月03日 14:17, David Miller 写道:
> From: Amerigo Wang<amwang@redhat.com>
> Date: Mon, 28 Feb 2011 20:30:04 +0800
>
>> bond_main.c is bloating, separate the procfs code out,
>> move them to bond_procfs.c
>>
>> Signed-off-by: WANG Cong<amwang@redhat.com>
>
> Please use Makefile rules to conditionally compile the new bond_procfs.o
> file, instead of wrapping almost the entire file with an ifdef.
>
> Put the dummy no-PROC_FS function stubs, as inlines, in bonding.h
>

Ok, will do it in the next update.

Thanks!
