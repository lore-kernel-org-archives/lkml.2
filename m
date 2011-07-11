Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab1GKOQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:16:48 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:57613 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab1GKOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:21 -0400
Date: Mon, 11 Jul 2011 23:15:19 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Glauber Costa <glommer@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>, tony.luck@intel.com,
        fenghua.yu@intel.com, xiantao.zhang@intel.com
Subject: Re: [PATCH v5 6/9] add jump labels for ia64 paravirt
Message-ID: <20110711141519.GE2548@valinux.co.jp>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-7-git-send-email-glommer@redhat.com> <4E1AF612.7040103@redhat.com> <4E1AF970.8030109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1AF970.8030109@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:24:00AM -0300, Glauber Costa wrote:
> On 07/11/2011 10:09 AM, Avi Kivity wrote:
>> On 07/04/2011 06:32 PM, Glauber Costa wrote:
>>> Since in a later patch I intend to call jump labels inside
>>> CONFIG_PARAVIRT, IA64 would fail to compile if they are not
>>> provided. This patch provides those jump labels for the IA64
>>> architecture.
>>>
>>
>> Please get an ack for this from the ia64 maintainer.
>>
>
> The ones listed in paravirt.c are CC'd. I am CC'ing all the other
> folks related to IA64 listed in MAINTAINERS now.
>
> Just a heads up so the new folks CC'd can get up to speed:
> I am proposing moving the steal time calculation to inside the core  
> scheduler. This move will make it easier for us to make decisions based  
> on steal time accounting on virtual machines. Ia64 KVM may or may not  
> follow this route - nothing that already works should break with this  
> change.
>
> This patch is needed only to avoid breaking compilation, since it  
> introduces two new variables that are expected be present when  
> CONFIG_PARAVIRT, to paravirt.c.

Although the ia64 maintainer is Tony Luck,
I'm fine with the change as the ia64 paravirt author.

Acked-by: Isaku Yamahata <yamahata@valinux.co.jp>

-- 
yamahata
