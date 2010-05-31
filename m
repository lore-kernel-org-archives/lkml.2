Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0EaODf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:03:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab0EaODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:03:34 -0400
Message-ID: <4C03C1B1.8010102@redhat.com>
Date: Mon, 31 May 2010 17:03:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
References: <1274897088-8587-1-git-send-email-glommer@redhat.com> <4BFE2A2F.50209@redhat.com> <20100527160248.GF3445@mothafucka.localdomain> <4C022C6D.7070701@redhat.com> <20100531134906.GA19104@mothafucka.localdomain>
In-Reply-To: <20100531134906.GA19104@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 04:49 PM, Glauber Costa wrote:
>
>> How are we failing to meet it?  All guests align to at least four bytes.
>>      
> static struct pvclock_wall_clock wall_clock;
>
> Unless there is something that the compiler does that I should take for granted,
> there is no alignment directive in there, and it could be anywhere.
>    

The compiler will align u32 and larger to 4 bytes on i386 (and align u64 
to 8 bytes on x86_64).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

