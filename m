Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0ESXLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0ESXLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:11:12 -0400
Message-ID: <4BF46FFE.1080903@redhat.com>
Date: Wed, 19 May 2010 20:10:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: Does anyone care about gcc 3.x support for x86 anymore?
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF26.9050701@zytor.com> <1274217067.2485.9.camel@edumazet-laptop> <4BF308E9.4040809@zytor.com>
In-Reply-To: <4BF308E9.4040809@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Recently, we have seen an increasing number of problems with gcc 3.4 on
> x86; mostly due to poor constant propagation producing not just bad code
> but failing to properly eliminate what should be dead code.

I don't see any problem, as, if people are using gcc3, they are probably
not interested on the bleeding edge kernel. 

However, if the problems are just performance/dead code removal, I would 
just add a big warning if someone tries to compile x86 with it. I don't 
like very much the idea of having different minimum gcc requirements 
for each architecture, except if gcc is producing a broken code. 

Currently,Documentation/Changes list just a common minimal list for
everything - although the text describing gcc say that the "version 
requirements" may vary for each CPU type.

-- 

Cheers,
Mauro
