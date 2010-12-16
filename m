Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab0LPFAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 00:00:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59298 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0LPFAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 00:00:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XLNd16PGaIULxFQ3JNfdUGkcingexzTrUWhIC4UxX41zjsTt4repo2+GgwhyhEI3iX
         hDCI4wk3GGu1jCLj+JKV/ooHtZe0fdCsWM3MhImK0RJgSD9vjojLQhj4/r8cLdm+0xNl
         r6C97eS0SuddvQZTr+ui3ZGozsh+XJgcsQfV4=
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Junchang Wang <junchangwang@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Xinan Tang <xinan.tang@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikc+QTPH2He=fKgWiRGk=6sn9Phaa259YdkQNix@mail.gmail.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	 <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	 <1292446118.2603.11.camel@edumazet-laptop>
	 <AANLkTikc+QTPH2He=fKgWiRGk=6sn9Phaa259YdkQNix@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 06:00:27 +0100
Message-ID: <1292475627.2603.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 décembre 2010 à 09:52 +0800, Junchang Wang a écrit :
> On Thu, Dec 16, 2010 at 4:48 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> With this patch, the user-space receiving speed on a Intel SR1690 server with
> >> a single L5640 6-core processor and a single ixgbe-based NIC goes from 0.73Mpps
> >> to 4.20Mpps, nearly a linear speedup. A Intel SR1625 server two E5530 4-core
> >> processors and a single ixgbe-based NIC goes from 0.80Mpps to 4.6Mpps. We noticed
> >> the performance penalty comes from NUMA memory allocation.
> >>
> >
> > ??? please elaborate on these NUMA memory allocations. This should be OK
> > after commit 564824b0c52c34692d (net: allocate skbs on local node)
> >
> Hi Eric,
> Commit 564824b0c52c34692d had been used in the experiments, but the problem
> remained unsolved.
> 
> SLUB was used, and both servers were equipped with 8G physical memory.
> Is there any
> additional information I can provide?
> 

Yes, sure, you could provide a description of the bench you used, and
data you gathered to make the conclusion that NUMA was a problem.



