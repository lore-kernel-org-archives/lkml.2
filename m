Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2A0GJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:09:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44598 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2A0GJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:09:12 -0500
Message-ID: <1327644547.2919.11.camel@edumazet-laptop>
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
Date: Fri, 27 Jan 2012 07:09:07 +0100
In-Reply-To: <m1zkdacbsx.fsf@fess.ebiederm.org>
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
	 <1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F212E7E.2040801@parallels.com>
	 <1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <m1zkdacbsx.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 14:57 -0800, Eric W. Biederman a écrit :

> It is not a chicken and egg problem.  It is a bug in caif.
> caif is claiming to be a network device when it is acting as a subsytem.
> That means it is being initialized too late.
> 

Ah ok !

> Untested but this should trivially fix the problem, and a bunch
> of others of the same ilk.
> 

Hmm, please refrain from using "trivially" or "trivial", you're not
fooling anyone.

Truth is this netns layer is horribly complex, since this CAIF bug
needed no more than four patch attempts and lastly your own work before
finding the root cause.

Thanks


