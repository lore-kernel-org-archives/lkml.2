Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0DAHQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:16:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54814
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab0DAHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:15:55 -0400
Date: Thu, 01 Apr 2010 00:15:56 -0700 (PDT)
Message-Id: <20100401.001556.24588152.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: herbert@gondor.apana.org.au, henne@nachtwindheim.de,
       steffen.klassert@secunet.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100331202931.146ef1b5.akpm@linux-foundation.org>
References: <20100331180445.98dbcb55.akpm@linux-foundation.org>
	<20100401013845.GA19580@gondor.apana.org.au>
	<20100331202931.146ef1b5.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 31 Mar 2010 20:29:31 -0400

> Thing is, this isn't net code and it isn't crypto code - it's a
> kernel-wide utility.

Thanks goodness, because if we had put a private copy in the
networking or the crypto code someone would have given us a hard time.

Wait a second... we're being given a hard time anyways. :-)

Kidding aside, why didn't anyone show any interest in the patch when
it was posted to lkml?  You can say it was smoothered together with
some crypto stuff, but that was absolutely the logical thing to do
because the follow-on crypto patches showed what the thing was going
to be used for.
