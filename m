Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2HIUUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:20:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46021 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2HIUTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:19:04 -0400
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <CACLa4ptkvKj2GT4ZL+msMuWOHW885Hugk8nz3hvptOoY9-totw@mail.gmail.com>
References: <50215A7E.8000701@linaro.org>
	<1344462889.28967.328.camel@edumazet-glaptop>
	<5022FD9A.4020603@schaufler-ca.com>
	<1695034.0lrQgQPOMT@sifl>
	<1344523833.28967.996.camel@edumazet-glaptop>
	<CACLa4ptkvKj2GT4ZL+msMuWOHW885Hugk8nz3hvptOoY9-totw@mail.gmail.com>
Date: Thu, 9 Aug 2012 16:19:03 -0400
Message-ID: <CAHC9VhQo8bh45qcMDo3cC=a0RA50zwBMftbZ3KGdLEXUapuvtw@mail.gmail.com>
Subject: Re: [PATCH] ipv4: tcp: security_sk_alloc() needed for unicast_sock
From: Paul Moore <paul@paul-moore.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 4:06 PM, Eric Paris <eparis@parisplace.org> wrote:
> I'm going to work right now on exposing the equivalent struct sock LSM
> interface so we can call that as well.  But it's going to take me a
> bit.

Before you go too far down this path, can you elaborate on what
exactly you mean by the above?

I'm asking because I'm not convinced the labeling, either the old way
or the new way, was 100% correct and I think we're going to need to
change things regardless.  I'm just not sure what the right solution
is just yet.

-- 
paul moore
www.paul-moore.com
