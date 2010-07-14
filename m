Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0GNH6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:58:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0GNH6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J/7ZCRjA9nDEPDijwqPOZDw9Em4j1mEcfhVk7g0Rj8O3zp4umAAfncI8yewB06CNz1
         sRzzjHs/7B4SU+eLZD7IFDUchnDvsSybqjlrQzz3JB827+PGa5q/L5G7B3J0wIRDWVWz
         CxTextVQINwCrWZQHNoMLDamb/UE2mjdyxtLM=
Message-ID: <4C3D6E0F.20605@garzik.org>
Date: Wed, 14 Jul 2010 03:58:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org> <4C25CC18.2070507@kernel.org> <4C2DFAB0.3020703@kernel.org> <4C384620.8040808@kernel.org>
In-Reply-To: <4C384620.8040808@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 06:06 AM, Tejun Heo wrote:
> On 07/02/2010 04:41 PM, Tejun Heo wrote:
>> Hello, Jeff.
>>
>> So, something like the following.  This should be applied on top of
>> the two previous libata patches.  The amount of code in the hot path
>> is very small.  Compared to the cpu actually taking an interrupt and
>> accessing hardware, it should be negligible, and this will give us
>> working and acceptably performing systems in the presence of most
>> types of IRQ problems.
>
> Ping.

Give me another day or two.  I'm working up an alternate patch for 
demonstration (still use the irq-expecting api, but differently).

	Jeff



