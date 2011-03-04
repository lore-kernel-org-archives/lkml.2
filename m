Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab1CDPV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:21:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63571 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1CDPVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ALQiz0z5DZVKTa3bFaeAnN037VUyUPHnZRyKrFZBuCsCIoyFm9N/mBXBc0ErFKXvMr
         Eyo24JBVNusaCrvq363c/MY7hF0hroHLKS/6zwDrT+SlAcbAaHcicIQHTTqRzAsK5zbl
         FHTNDFYQSvepNdnrKZ83ZkgvsRocgAX25BlYI=
MIME-Version: 1.0
In-Reply-To: <20110304140404.GK11359@redhat.com>
References: <20110303135819.GA2620@darkstar>
	<20110303145908.GA32154@redhat.com>
	<AANLkTi=sz7By1HaJ+HhFaQDWyUnrR5PNyAcL0uPnEt-K@mail.gmail.com>
	<20110304140404.GK11359@redhat.com>
Date: Fri, 4 Mar 2011 23:21:54 +0800
Message-ID: <AANLkTi=a7tuNOqqiWE-Ncd5YnsUKUOveypopTfApOmHX@mail.gmail.com>
Subject: Re: [PATCH 01/05] use proc_dointvec_minmax to check boundaries while needed
From: Dave Young <hidave.darkstar@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 10:04 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Mar 04, 2011 at 09:41:59AM +0800, Dave Young wrote:
>> On Thu, Mar 3, 2011 at 10:59 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Thu, Mar 03, 2011 at 09:58:20PM +0800, Dave Young wrote:
>> >> proc_dointvec doesn't check extra minmax params, use proc_dointvec_minmax
>> >> instead of proc_dointvec for cases need boundaries check.
>> >
>> > Is this patch needed, if you are basically changing it again in patches 3
>> > and 5?
>>
>> Sure if 3 and 5 is acked, if someone object them then this is good?
>
> Ok.  I guess I would have posted patches 2-4 first to get everyone's
> opinion.  Then if the reaction was negative, try with patch 1.
>
> Personally I don't see any problems with patches 2-4.  Then again I don't
> deal with sysctl that much, so I don't what rules there are in that area of
> code.

No problem, I will try resend 2-4 with first one merged, Thanks.
-- 
Regards
dave
