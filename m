Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1BJUCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:02:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55390 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1BJUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BFau7YnD/jKBqe9iLOE/XNaofkijpox7UT2UIDuFBWNl4sMDEDAghrO+5m9VvH31Rp
         UNRDy40fD3TY/b6DoCkEvORDPrSFljPH9bW1+Ui8jINvoAY00bRbhbWrtd4uL0+92pIt
         0WuelpeLC2bgAGkshkr2M2URgZPT71mrSDOHI=
MIME-Version: 1.0
In-Reply-To: <20110210190843.GE20676@ghostprotocols.net>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com>
	<20110210190843.GE20676@ghostprotocols.net>
Date: Thu, 10 Feb 2011 12:02:20 -0800
X-Google-Sender-Auth: m1aU5MD-tRf4QA-LcunbtvP2nXg
Message-ID: <AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
Subject: Re: 2.6.37 kernel warning in perf_events code
From: Arun Sharma <arun@sharma-home.net>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:08 AM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Wed, Feb 09, 2011 at 06:50:09PM -0800, Arun Sharma escreveu:
>> [ Not sure if this is known and fixed in newer kernels. My machine
>> becomes unusable after this warning triggers ]
>>
>> perf record -g -p <pid> cs -o csw.data -- sleep 3
>
> What kernel are you using? Peter, rings any bells?

Stock 2.6.37.

 -Arun
