Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1CWWQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:16:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:45237 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1CWWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:16:49 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Pat Kane <pekane52@gmail.com>
Subject: Re: [PATCH v2] net/unix: Add secdata to unix_stream msgs
Date: Wed, 23 Mar 2011 18:16:46 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.35-gentoo-r15; KDE/4.6.1; x86_64; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>, Eric Paris <eparis@redhat.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, cxzhang@watson.ibm.com, sds@tycho.nsa.gov,
        jmorris@namei.org, eparis@parisplace.org,
        LSM <linux-security-module@vger.kernel.org>
References: <1300840717-4413-1-git-send-email-pekane52@gmail.com> <4D8A1BB4.4030709@schaufler-ca.com> <AANLkTik55CAKfU5v4PE87h26vwAMy8vV7rhMmu9EA19B@mail.gmail.com>
In-Reply-To: <AANLkTik55CAKfU5v4PE87h26vwAMy8vV7rhMmu9EA19B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231816.46266.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 23, 2011 4:23:35 PM Pat Kane wrote:
>   >> On Tue, 2011-03-22 at 19:32 -0700, David Miller wrote:
>   >>> The SELINUX hook implementations even have "_dgram()" in their names.
> 
> The LSM hook that I am having problems with, and that the patch fixes
> is  "secid_to_secctx()"  not "socket_getpeersec_dgram()".

Can you explain the problem you are having?  I'm specifically interested in 
who is calling secid_to_secctx() on a AF_UNIX stream packet.

Adding the secid token to a AF_UNIX stream packet isn't likely to be the right 
solution, although until we hear what the core problem is, I'm not sure we can 
offer any fixes.

--
paul moore
linux @ hp
