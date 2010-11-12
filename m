Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0KLScY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:32:24 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:44397 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754288Ab0KLScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:32:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=HYgco+radhVjskMNskHRAS7WyiXsPfQZpAHZ6U4aV9b+91E4IG217DLToEqs7kNt4Thlft2F6SAtFA56WOYDrmMkwr6Oyc9hggncPNhQzByaj0NjA2rTiaFikQrrRhuvHdDqqpfmBfHxUS2POuKvjVNiK2xEE0wafHothrUAgM8=;
Date: Fri, 12 Nov 2010 21:31:08 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, David Lamparter <equinox@diac24.net>,
        Eric Paris <eparis@redhat.com>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com,
        Damian Lukowski <damian@tvk.rwth-aachen.de>
Subject: Re: a problem tcp_v4_err()
Message-ID: <20101112183108.GB20459@ms2.inr.ac.ru>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <1289578108.3083.95.camel@localhost.localdomain> <1289578532.3185.265.camel@edumazet-laptop> <20101112163543.GB122902@jupiter.n2.diac24.net> <4CDD7145.8070606@trash.net> <20101112175715.GB16544@ms2.inr.ac.ru> <1289585578.3185.268.camel@edumazet-laptop> <1289586114.3185.271.camel@edumazet-laptop> <1289586477.3185.273.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289586477.3185.273.camel@edumazet-laptop>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Oh well, it seems you are right (backlog processing)

Exactly.

Alexey
