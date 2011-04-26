Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1DZVFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:05:18 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:47337 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754071Ab1DZVFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:05:16 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB73357.5020403@verizon.net>
Date: Tue, 26 Apr 2011 17:04:23 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Arnaud Lacombe <lacombar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>,
        <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] kbuild: mark unicore32 header export as broken
References: <4DB4AEF7.3090607@verizon.net>	<BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com> <BANLkTikFUhiDSEM_yLtbzmhfdUWBDv71ww@mail.gmail.com>
In-Reply-To: <BANLkTikFUhiDSEM_yLtbzmhfdUWBDv71ww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2011 1:07 PM, Américo Wang wrote:
> On Tue, Apr 26, 2011 at 2:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Hi,
>>
>> On Sun, Apr 24, 2011 at 7:15 PM, Peter Foley <pefoley2@verizon.net> wrote:
>>> This patch marks userspace header export for unicore32 as broken so that
>>> it is skipped when running make headers_install_all.
>>>
>> Why ?
>>
>> I would expect you to send this to arch/unicore32 maintainer too, he
>> is not in the CC: list.
> 
> +1
> 
> If you see errors when install kernel headers on unicore32, fix them instead
> of marking it as broken.

The problem with unicore32 is that it generates various stub headers at compile time in include/generated/asm.
I believe the unicore32 maintainer is already aware of headers_install not working (see https://lkml.org/lkml/2011/1/8/11).
I'm adding him to the CC list on this email. 
