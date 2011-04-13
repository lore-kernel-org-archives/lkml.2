Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1DMLWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:22:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54714 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab1DMLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BWTHhPAc9C+/GegAE+fKoAno8784B1ZSDBM6rDxJRmLwuEY4HB2+1+uYlq5YWIdlZb
         w1nY8zRXhjE5V6mvTO/Ilxn3XK8oDW/znyFxHd415j168RvpvKt2s5A/5ZasmMGLc3Yx
         oBPhsj15hp9g0C6TDfAm0oFoIylUjtj5id17w=
Date: Wed, 13 Apr 2011 15:22:10 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: solar@openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110413112210.GA6948@albatros>
References: <20110412.142534.183049889.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412.142534.183049889.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 14:25 -0700, David Miller wrote:
> I have no fundamental objections to this change and I'll be happy to
> apply it after we iron out a few details.

Great!

> First, please get rid of the debug option, we have pr_debug() which can
> be dynamically turned on and off at run time these days.

OK.

> Second, if this is a bonafide core facility we'd like everyone to use,
> let's make it so.  I want it so that every ping binary can expect this
> facility to be there if the kernel is new enough.
> 
> So let's get rid of the config option.

OK.

> Finally, longer term, I'd really like to see ipv6 support for this
> feature as well.

Definitely.

For ICMPv6 we should recognize what message types are OK to send by
non-root users and what types are privileged.  We just didn't do this
yet.


Thank you for the review,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
