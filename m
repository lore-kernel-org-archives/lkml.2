Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0DUJ3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:29:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0DUJ3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:29:50 -0400
Subject: Re: perf top broken on ppc64
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271827490-sup-48@au1.ibm.com>
Date: Wed, 21 Apr 2010 11:29:44 +0200
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <12E39DE6-0957-43CD-8DD4-24970AAF45D3@suse.de>
References: <594EC076-62C6-473D-9AF2-47AEE4B57ED3@suse.de> <1271827490-sup-48@au1.ibm.com>
To: Ian Munsie <imunsie@au1.ibm.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 21.04.2010, at 07:29, Ian Munsie wrote:

> Excerpts from Alexander Graf's message of Wed Apr 21 09:21:36 +1000 2010:
>> Hi,
>> 
>> While trying to find out performance bottlenecks in KVM for PowerPC I
>> figured I'd try and use "perf top" to see what's going on in the
>> system. This works great on my G4, but doesn't on the Powerstation
>> (970MP).
>> 
>> The only weird thing I can imagine about this setup is that I'm
>> running 32 bit userland on a 64 bit kernel. So I went ahead and
>> compiled perf for ppc64 - without any change:
> 
> I'm using 32 bit userland and 64 bit kernel on a PowerPC box and it's working for me.
> Are you building perf from the tip tree?

I'm using kvm.git which is pretty close to tip. The version says something 2.6.34-rc3'ish. Has anything significantly changed since then?

Either way - I'll give it a try.


Alex

