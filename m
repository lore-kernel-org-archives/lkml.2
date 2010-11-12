Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab0KLGYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:24:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37792 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0KLGYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aASk2bI87xXQ0aZ2TFCASCKiPL4li9EIzVZlAz7QRPDpFFkTEBDCjId0XpA9+Fjl2l
         d2fYmENkU/3OJAsrRkHNDlGEH3v/m38lysD1P3s50LcDs4zguiawbqRZI1GqTwgBJaKh
         rrR1MObFwCLWdyz7E6EyrlpRZ2OItPql2vG8g=
Date: Fri, 12 Nov 2010 14:28:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
Message-ID: <20101112062831.GA5660@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
 <1289489007.17691.1310.camel@edumazet-laptop>
 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>>
>> Is TILE using ticket spinlocks ?
>>

Eric, yes.


>
>What ticket spinlocks means? Could you explain a little, pls:) I'm not
>familiar with Linux kernel, I'm trying to get more understanding of it
>since I'm working on Linux platform now.
>

You might want to search "ticket spinlock" with google. :)

Briefly speaking, it is introduced to solve unfairness
of the old spinlock implementation. In linux kernel, not all
arch implement this. X86 implementation is done by Nick with
asm code, while tile uses C to implement it.

