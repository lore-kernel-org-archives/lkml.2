Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1CORhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:37:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22293 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758188Ab1CORhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:37:34 -0400
Message-ID: <4D7FA3A6.4000305@parallels.com>
Date: Tue, 15 Mar 2011 20:36:38 +0300
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@openvz.org" <skinsbursky@openvz.org>
Subject: Re: [PATCH] RPC: return task->tk_status from rpc_wait_for_completion_task()
 in case of successfull task completion
References: <20110315141951.16564.72417.stgit@localhost6.localdomain6> <1300199215.14093.1.camel@lade.trondhjem.org>
In-Reply-To: <1300199215.14093.1.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.03.2011 17:26, Trond Myklebust пишет:
> On Tue, 2011-03-15 at 17:20 +0300, Stanislav Kinsbursky wrote:
>> Some NFS and NLM routines doesn't check RPC task tk_status if
>> rpc_wait_for_completion_task() returned 0 but have to.
>
> Examples please. I'm not aware of any such cases.
>
> Cheers
>     Trond
>

You are right. I was confused with different logic for NSFv4, NLM and NFSv3.
Drop the patch.
Sorry.

-- 
Best regards,
Stanislav Kinsbursky
