Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0DUF3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:29:52 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46517 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0DUF3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:29:51 -0400
Content-Type: text/plain; charset=UTF-8
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf top broken on ppc64
From: Ian Munsie <imunsie@au1.ibm.com>
To: Alexander Graf <agraf@suse.de>
In-reply-to: <594EC076-62C6-473D-9AF2-47AEE4B57ED3@suse.de>
References: <594EC076-62C6-473D-9AF2-47AEE4B57ED3@suse.de>
Date: Wed, 21 Apr 2010 15:29:19 +1000
Message-Id: <1271827490-sup-48@au1.ibm.com>
User-Agent: Sup/0.10.2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Alexander Graf's message of Wed Apr 21 09:21:36 +1000 2010:
> Hi,
> 
> While trying to find out performance bottlenecks in KVM for PowerPC I
> figured I'd try and use "perf top" to see what's going on in the
> system. This works great on my G4, but doesn't on the Powerstation
> (970MP).
> 
> The only weird thing I can imagine about this setup is that I'm
> running 32 bit userland on a 64 bit kernel. So I went ahead and
> compiled perf for ppc64 - without any change:

I'm using 32 bit userland and 64 bit kernel on a PowerPC box and it's working for me.
Are you building perf from the tip tree?

Cheers,
-Ian
