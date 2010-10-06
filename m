Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab0JFTXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:23:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58433 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0JFTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:23:49 -0400
Message-ID: <4CACCCC3.5070203@cs.helsinki.fi>
Date: Wed, 06 Oct 2010 22:23:47 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 6
References: <20101006163632.c1943a38.sfr@canb.auug.org.au> <AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com> <20101006174831.02cf1691.sfr@canb.auug.org.au> <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com> <alpine.DEB.2.00.1010061311430.31538@router.home> <4CACBCDE.3000701@cs.helsinki.fi> <alpine.DEB.2.00.1010061319580.4817@router.home>
In-Reply-To: <alpine.DEB.2.00.1010061319580.4817@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.10.2010 21.20, Christoph Lameter wrote:
> On Wed, 6 Oct 2010, Pekka Enberg wrote:
>
>> You already acked my patch to fix it:
>>
>> http://lkml.org/lkml/2010/10/6/194
>
> That is a different issue.

It's the exact same build error and hotplug_memory_notifier() works just 
fine on !CONFIG_MEMORY_HOTPLUG.

			Pekka

