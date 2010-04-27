Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0D0BbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:31:01 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57918 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0D0BbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:31:00 -0400
Content-Type: text/plain; charset=UTF-8
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf top broken on ppc64
From: Ian Munsie <imunsie@au1.ibm.com>
To: Alexander Graf <agraf@suse.de>
In-reply-to: <12E39DE6-0957-43CD-8DD4-24970AAF45D3@suse.de>
References: <594EC076-62C6-473D-9AF2-47AEE4B57ED3@suse.de> <1271827490-sup-48@au1.ibm.com> <12E39DE6-0957-43CD-8DD4-24970AAF45D3@suse.de>
Date: Tue, 27 Apr 2010 11:30:21 +1000
Message-Id: <1272331742-sup-1208@au1.ibm.com>
User-Agent: Sup/0.10.2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm using 32 bit userland and 64 bit kernel on a PowerPC box and it's working for me.
> > Are you building perf from the tip tree?
> 
> I'm using kvm.git which is pretty close to tip. The version says something 2.6.34-rc3'ish. Has anything significantly changed since then?
> 
> Either way - I'll give it a try.


Hey Alex,

Did perf from the tip tree work for you?

Cheers,
-Ian
