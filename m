Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1GACvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1GACvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:51:07 -0400
Message-ID: <4E0D3612.6040701@redhat.com>
Date: Thu, 30 Jun 2011 23:50:58 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>	 <1309361388-30163-8-git-send-email-glommer@redhat.com> <1309470871.12449.608.camel@twins>
In-Reply-To: <1309470871.12449.608.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 06:54 PM, Peter Zijlstra wrote:
> On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
>> This patch accounts steal time time in kernel/sched.
>> I kept it from last proposal, because I still see advantages
>> in it: Doing it here will give us easier access from scheduler
>> variables such as the cpu rq. The next patch shows an example of
>> usage for it.
>>
>> Since functions like account_idle_time() can be called from
>> multiple places, not only account_process_tick(), steal time
>> grabbing is repeated in each account function separatedely.
>>
>
> That changelog is so going to frustrate someone trying to re-create your
> thinking in a year's time. They really don't care about the last
> proposals and the next patch.

You're right. I'll review all changelogs and rewrite them as needed.
