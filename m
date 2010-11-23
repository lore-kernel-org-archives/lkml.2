Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0KWHGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:06:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55219 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0KWHGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:06:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OojGxKHTZeDKqf/CzjWgh/rE0Sj7lkQBpo+Zx7pWsiUv3wWCJNnQ6PqiiKIAudyfWS
         F1pG1pw3+hQYbuqUZeJT6anzQuyUXr/qpNkAST/3USXRuVPDopO2loodZQHAwDmwDdxL
         Kw5U4VKTajnmKR9HyASrrVr0dAg9IYra0R+6o=
MIME-Version: 1.0
In-Reply-To: <20101119143416.GA5558@nowhere>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	<1290063401-25440-5-git-send-email-dengcheng.zhu@gmail.com>
	<20101119143416.GA5558@nowhere>
Date: Tue, 23 Nov 2010 15:06:17 +0800
Message-ID: <AANLkTi=xZZMGdS62tdY62ifgEEV8Jpo5y5=MrCb5HvaK@mail.gmail.com>
Subject: Re: [PATCH 4/5] MIPS/Perf-events: Work with the new callchain interface
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, will.deacon@arm.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, MIPS Perf-events got added in recently and missed some important
commits.


Thanks!

Deng-Cheng


2010/11/19 Frederic Weisbecker <fweisbec@gmail.com>:
> On Thu, Nov 18, 2010 at 02:56:40PM +0800, Deng-Cheng Zhu wrote:
>> This is the MIPS part of the following commits by Frederic Weisbecker:
>>
>> f72c1a931e311bb7780fee19e41a89ac42cab50e
>>       perf: Factorize callchain context handling
>> 56962b4449af34070bb1994621ef4f0265eed4d8
>>       perf: Generalize some arch callchain code
>> 70791ce9ba68a5921c9905ef05d23f62a90bc10c
>>       perf: Generalize callchain_store()
>> c1a65932fd7216fdc9a0db8bbffe1d47842f862c
>>       perf: Drop unappropriate tests on arch callchains
>>
>> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
>> ---
>
>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> Why did I miss this arch? I did a grep on HAVE_PERF_EVENT or something,
> may be it hadn't it at that time?
>
> Thanks!
>
>
