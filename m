Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0LOU4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:56:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51011 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0LOU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Kmqbdyq8LkvN0PRRZen4yHdqJLg9uTTi7uxRX3ImLTpzVRGLU8bz1NYQ2r7YcbpbIm
         5SSNJddIsRC5iH/jFximHpgzjnmroLZekyqMMheKsNG2lJyp9LqO3LZIkwnNB/1oSowD
         gG/VroRBcs/+GA511tNKHKVKrSCb3k8pRmBNo=
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Xinan Tang <xinan.tang@intel.com>,
        Junchang Wang <junchangwang@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1292446118.2603.11.camel@edumazet-laptop>
References: <cover.1292405004.git.fenghua.yu@intel.com>
	 <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
	 <1292446118.2603.11.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 21:56:07 +0100
Message-ID: <1292446567.2603.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 décembre 2010 à 21:48 +0100, Eric Dumazet a écrit :
> Le mercredi 15 décembre 2010 à 12:02 -0800, Fenghua Yu a écrit :
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > Multiqueue and multicore provide packet parallel processing methodology.
> > Current kernel and network drivers place one queue on one core. But the higher
> > level socket doesn't know multiqueue. Current socket only can receive or send
> > packets through one network interfaces. In some cases e.g. multi bpf filter
> > tcpdump and snort, a lot of contentions come from socket operations like ring
> > buffer. Even if the application itself has been fully parallelized and run on
> > multi-core systems and NIC handlex tx/rx in multiqueue in parallel, network layer
> > and NIC device driver assemble packets to a single, serialized queue. Thus the
> > application cannot actually run in parallel in high speed.

I forgot to say that your patches are not against net-next-2.6, and not
apply anyway.

Always use David trees for networking patches...


