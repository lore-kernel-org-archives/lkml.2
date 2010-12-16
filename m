Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0LPBwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:52:31 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:60950 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0LPBw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tj3m2++Ir8HEidX026FeTkBQacmW/9GOuECyxCD+FK8WL/Kwt4yVigpy/TNOBoQNQn
         4UarANK9nFNdm9eyGcrEJjyo6Dkv9pkgOisvJFR4aQsD3HxxFsu3+lMljlkW8iRh6Dhz
         xv3EBQMaKiuVp82ZXht3YN2EpnEwN92fGscIc=
MIME-Version: 1.0
In-Reply-To: <1292446118.2603.11.camel@edumazet-laptop>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	<46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	<1292446118.2603.11.camel@edumazet-laptop>
Date: Thu, 16 Dec 2010 09:52:28 +0800
Message-ID: <AANLkTikc+QTPH2He=fKgWiRGk=6sn9Phaa259YdkQNix@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Junchang Wang <junchangwang@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Xinan Tang <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 4:48 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> With this patch, the user-space receiving speed on a Intel SR1690 server with
>> a single L5640 6-core processor and a single ixgbe-based NIC goes from 0.73Mpps
>> to 4.20Mpps, nearly a linear speedup. A Intel SR1625 server two E5530 4-core
>> processors and a single ixgbe-based NIC goes from 0.80Mpps to 4.6Mpps. We noticed
>> the performance penalty comes from NUMA memory allocation.
>>
>
> ??? please elaborate on these NUMA memory allocations. This should be OK
> after commit 564824b0c52c34692d (net: allocate skbs on local node)
>
Hi Eric,
Commit 564824b0c52c34692d had been used in the experiments, but the problem
remained unsolved.

SLUB was used, and both servers were equipped with 8G physical memory.
Is there any
additional information I can provide?

Thanks.
-- 
--Junchang
