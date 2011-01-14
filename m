Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1ANDI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:08:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44234 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1ANDI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b07DSbTkTaE0ECFHNj+mcjjmjt5GEd7Z5zkkJ1yhhd09/LI5f/3ukuAohVrQLiFPh1
         w0FveGqWo3K9j7aFETkrQzW4lMEDxGYstiWPj/ZgAdHaEsZC1q0b1Jm9R/nS0QJwQOis
         rqhbMZqRjBmxOnnbP1TI4g5B/z34ihvHm7fLM=
Subject: Re: [PATCH v1 2/2] TCPCT API sockopt update to draft -03
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D2FBC34.6050901@gmail.com>
References: <4D2DE824.10205@gmail.com>	<4D2DEC0A.70608@gmail.com>
	 <20110112105608.793787b2@s6510>	<4D2F3723.9040405@gmail.com>
	 <AANLkTinhnaF3-scKnTOC5rF68+5otVW2NG3v1y80L0k6@mail.gmail.com>
	 <4D2FBC34.6050901@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 04:08:23 +0100
Message-ID: <1294974503.3403.95.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 13 janvier 2011 à 22:00 -0500, William Allen Simpson a écrit :

> Is this supposed to be humorous?  Maybe folks here find it amusing that
> somebody thinks they know more than the *author* about the contents of the
> document?  Did you note the words above?  That is, "very recent changes"?
> 
> Perhaps you are viewing an older cached version.  Please check for the
> current month on every page: "January 2011".
> 
> We discussed -- and ultimately decided -- these changes in private email
> during the independent review process before making them available to the
> general public.  That's how the RFC publication procedure works.
> 
> I tried to be helpful to the Linux community in advance of publication, so
> you would be prepared.  I'm sorry that the community here is so lacking in
> appreciation for my efforts on your behalf.
> 
> As always, what you actually do with my code is up to you....
> --


Next time you come here, provide an up2date link for us mere mortals, so
that we can check your code against your claims. We dont trust you
anymore, we had to fix several bugs.

This is getting ridiculous.

As I said, we are going to wait for official RFC, because its time
consuming to review your patches, and nobody asked for early TCPCT
coding in linux kernel (you already said your buddies dont care at all)



