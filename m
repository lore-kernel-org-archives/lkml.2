Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0CZWzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:55:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55486 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0CZWzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CDX4rqjyvf+JolieKNg3D0Q6LQ6cI58vTB11JSNYcSI7l23+3vagv+ah2rQpiNrb5t
         W6cu3tliTsMAUML2CfxPy787rbEhjON9heXxoNWzGR8QI0DvzQzkJyx4++sc8qY1J12b
         cGqKKUAsSqssX/ja/atpgtivNNvphEzFOvJog=
MIME-Version: 1.0
In-Reply-To: <1269643470.2256.17.camel@edumazet-laptop>
References: <20100326223530.GA11817@xpc.home>
	 <1269643470.2256.17.camel@edumazet-laptop>
Date: Fri, 26 Mar 2010 17:55:18 -0500
Message-ID: <84621a61003261555q2c78f6a8o5b438113bed6bd2@mail.gmail.com>
Subject: Re: [PATCH] Add MSG_WAITFORONE flag to recvmmsg
From: Brandon Black <blblack@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 5:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Hmmm, no need to test !datagram, just do :
>
>        ++datagrams;
>
>        if (flags & MSG_WAITFORONE)
>                flags |= MSG_DONTWAIT;
>

Ok.  I've never been through this process before.  Do I resubmit a new
subject/thread with the changed patch and [PATCH v2] at this point?
Any other nits about how the patch was sent before I do?

Thanks,
-- Brandon
