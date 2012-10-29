Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2J2LbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:31:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42092 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab2J2LbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:31:09 -0400
Message-ID: <508E68F7.5080402@gmail.com>
Date: Mon, 29 Oct 2012 19:31:03 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paolo Valente <paolo.valente@unimore.it>
CC: jhs@mojatatu.com, davem@davemloft.net, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH RFC] pkt_sched: enable QFQ to support TSO/GSO
References: <20121029085106.GA3733@paolo-ThinkPad-W520> <508E63AD.20803@gmail.com> <508E6783.2080403@unimore.it>
In-Reply-To: <508E6783.2080403@unimore.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 07:24 PM, Paolo Valente wrote:
> Il 29/10/2012 12:08, Cong Wang ha scritto:
>>
>> Please respect people who helps you to test it:
>>
>> Tested-by: Cong Wang <amwang@redhat.com>
> Oops, really sorry about that. I did not mean to hide your contribution.
> I am just not familiar with the process.

No problem. :)


> Thanks, I will integrate this and possible other suggestions in a new
> version of the patch.

While you are on it, please check your patch with 
./scripts/checkpatch.pl, it complains there are some trailing 
whitespaces in your patch. ;)

