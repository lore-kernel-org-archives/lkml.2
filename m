Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1DZK1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:27:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64174 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1DZK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LOO/RIkDZ8PVe2X1I44V2Ky7FRJ1R1yAjElprSGsDrpVjZPArT6ZAQ5L21J3t2h1FD
         tsp0xlADJyu5vJtF2vS63ok1yxa623s8OU1AeKJnmi8j3ui2YgoNn+GNfWuwsg5Ng8eD
         aKhJLKd1+0XQqxDFpVyLdGx/VRs15YpWgnWuI=
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 12:27:48 +0200
Message-ID: <1303813668.3358.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 avril 2011 à 13:08 +0300, Pekka Enberg a écrit :

> That's just kmemcheck fault handler warning about in_nmi(). You could
> try to make the relevant perf allocations use __GFP_NOTRACK and/or
> SLAB_NOTRACK to avoid page faulting in the perf nmi handler.

Yes, I am going to try that, thanks


