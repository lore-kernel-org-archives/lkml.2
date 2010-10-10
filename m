Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0JJP45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0JJP44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:56:56 -0400
Message-ID: <4CB1E22F.9060008@redhat.com>
Date: Sun, 10 Oct 2010 17:56:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com> <4CAD97D0.70100@redhat.com> <20101007174716.GD2397@redhat.com> <4CB0B4BA.5010901@redhat.com> <20101010072946.GJ2397@redhat.com> <4CB1E1ED.6050405@redhat.com>
In-Reply-To: <4CB1E1ED.6050405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/10/2010 05:55 PM, Avi Kivity wrote:
>> There is special completion that tells guest to wake all sleeping tasks
>> on vcpu. It is delivered after migration on the destination.
>>
> >
>
> Yes, I saw.
>
> What if you can't deliver it?  is it possible that some other vcpu 
> will start receiving apfs that alias the old ones?  Or is the 
> broadcast global?
>

And, is the broadcast used only for migrations?


-- 
error compiling committee.c: too many arguments to function

