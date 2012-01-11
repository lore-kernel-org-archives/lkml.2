Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2AKRdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:33:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51377 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2AKRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120111161939.GI8752@moon>
References: <20120111161939.GI8752@moon>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 12:25:04 -0500
Message-ID: <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
Subject: Re: [RFC] on general object IDs again
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In turn doing everything in a manner of syscall "compare resources of two pids"
> gives up very slow speed because we will have to compare every pid resources
> with every other pids we're checkpointing.

Could you please write down pseudo code of your userland compare logic? When
and why do you need? I still don't like this idea, but maybe I need to
understand your
requerement before putting negative comments.
