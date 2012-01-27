Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2A0HHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:07:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34436 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2A0HHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:07:41 -0500
Message-ID: <1327648054.2919.28.camel@edumazet-laptop>
Subject: Re: [PATCH] netns: fix net_alloc_generic()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>
Date: Fri, 27 Jan 2012 08:07:34 +0100
In-Reply-To: <m1k44d8wkw.fsf@fess.ebiederm.org>
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
	 <1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F212E7E.2040801@parallels.com>
	 <1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <m1zkdacbsx.fsf@fess.ebiederm.org>
	 <1327644547.2919.11.camel@edumazet-laptop>
	 <m1k44d8wkw.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 22:54 -0800, Eric W. Biederman a écrit :

> Now the common plumbing in net/core/net_namespace.c does count as
> complex.  The fact we missed such an obvious optimization opportunity
> for so long seems to confirm that.

This was probably masked by the 13 pointers initial value.

I find hard to believe some real setups need more than that !



