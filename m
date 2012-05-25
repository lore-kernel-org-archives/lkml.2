Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab2EYXKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:10:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51556 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2EYXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:10:21 -0400
MIME-Version: 1.0
In-Reply-To: <m2vcjjlwv0.fsf@firstfloor.org>
References: <CALKntY1wDFxzZX6ONgeVuNjBxi=bPA-0vhWJ-_NMXR37GNmvBQ@mail.gmail.com>
	<m2vcjjlwv0.fsf@firstfloor.org>
Date: Fri, 25 May 2012 19:10:20 -0400
Message-ID: <CALKntY1b_m1zAvMWFm7_rtpLn5S8tjZg2=fwiM5B-qWFwAKYLA@mail.gmail.com>
Subject: Re: native_save_fl taking good amount of time in profile
From: Xin Tong <xerox.time.tech@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i do not know its callers from the profile. one thing i am suspicious
of is that my kernel debug-info is wrong. by the way, what does the
function do ?

Thanks

Xin


On Fri, May 25, 2012 at 6:27 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Xin Tong <xerox.time.tech@gmail.com> writes:
>
>> I have collected a profile on the whole system. But the only thing
>> that is really running is a mysql database server. I have noticed that
>> there is a function in kernel that took 5% of the overall running
>> time. what does native_save_fl do ? does it make sense that
>> native_save_fl takes the most amount of time among all kernel
>> functions ?
>
> What are the callers (-g)? It does not make sense normally.
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
