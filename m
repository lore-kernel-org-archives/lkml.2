Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1FLIcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1FLIcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:32:04 -0400
Message-ID: <4DF47959.5050603@redhat.com>
Date: Sun, 12 Jun 2011 11:31:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>	<4DF1D0EF.7090109@jp.fujitsu.com> <BANLkTikkYevvkUeQz4YYGauF52YcDRdokQ@mail.gmail.com>
In-Reply-To: <BANLkTikkYevvkUeQz4YYGauF52YcDRdokQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 11:42 PM, Tony Luck wrote:
> You are right that we should have some better method - the
> shot-gun approach of hitting every task on every cpu in the hope
> that one of them will run our code soon sounds like overkill.
> Using some NMI-saf method to wake a single worker thread
> sounds a good idea for a subsequent clean up.
>

That's irq_work_queue().

-- 
error compiling committee.c: too many arguments to function

