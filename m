Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab0CaNJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:09:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52535 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab0CaNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:08:59 -0400
Date: Wed, 31 Mar 2010 15:08:55 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit
 transfers
Message-ID: <20100331130855.GG30807@buzzloop.caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
 <x2ve2d7436a1003310207t16a7d1d6r7853de2dfa647c6c@mail.gmail.com>
 <20100331090836.GA30801@buzzloop.caiaq.de>
 <k2he2d7436a1003310249v63878e0ahe1b398401937a225@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <k2he2d7436a1003310249v63878e0ahe1b398401937a225@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:49:49AM +0200, Michał Mirosław wrote:
> W dniu 31 marca 2010 11:08 użytkownik Daniel Mack <daniel@caiaq.de> napisał:
> > Hmm, that function isn't exported, and I didn't want to change this. You
> > say you'd prefer that? I can cook up something that does it, no problem.
> 
> BTW, I can't see any exported functions to access fn#0 directly from
> drivers. Maybe it's time to introduce them now - at least CCCR has
> some vendor-defined parts that drivers may want to access and there is
> a lot of place in CIS area that can be (ab)used by devices.

In fact, there is sdio_f0_{read,write}b() - I overlooked them. Will
resend a new patch.

Thanks for checking,
Daniel
