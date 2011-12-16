Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab1LPBrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:47:48 -0500
Received: from tundra.namei.org ([65.99.196.166]:38027 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1LPBrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:47:46 -0500
Date: Fri, 16 Dec 2011 12:47:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 8/15] apparmor: fix module parameter handling
In-Reply-To: <4EE9F46A.9090603@canonical.com>
Message-ID: <alpine.LRH.2.00.1112161247190.6028@tundra.namei.org>
References: <87pqfqsf4r.fsf@rustcorp.com.au> <4EE9F46A.9090603@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011, John Johansen wrote:

> On 12/14/2011 07:11 PM, Rusty Russell wrote:
> > The 'aabool' wrappers actually pass off to the 'bool' parse functions,
> > so you should use the same check function.  Similarly for aauint and
> > uint.
> > 
> yep, thanks Rusty
> 
> > (Note that 'bool' module parameters also allow 'int', which is why you
> > got away with this, but that's changing very soon.)
> > 
> > Cc: John Johansen <john.johansen@canonical.com>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: linux-security-module@vger.kernel.org
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: John Johansen <john.johansen@canonical.com>
> 

Applied to
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
