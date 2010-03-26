Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0CZQjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:39:31 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:43475 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0CZQj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v0eIjayY0wVvdh2c9stGAkCtq5+8WEl2KjnnsK2tarWiO71EoXt6YjDU8bPdFPlpXa
         aKd+WRAjieZrGc7DdLgfR8++AOqOnITHNIWJgkNZ3/vRxr+PWSOyuWgM7v8JFdHN4+8z
         34AkO4U+ePW4cmPq34h1ZfWV3AAWZMSoa+STM=
MIME-Version: 1.0
In-Reply-To: <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	 <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
Date: Fri, 26 Mar 2010 17:39:27 +0100
Message-ID: <v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 17:02, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> You should be able to manage that I'm sure:

Hopefully. We will see :)


> MODULE_PARM_DESC(ml_expode, "Set this to zero to disabling multilink \
>        fragmentation when talking to cisco devices");

To be exact, this is not a Linux vs. Cisco issue, but a Linux vs. world
issue.

At least the last-level support of Telefonica and QSC was definite and
adamant about not enabling fragmentation on _any_ PPP multi-link, ever.

Also, I am not sure if it would not be better to default to no
fragmentation and enable it optionally. I am aware that changing default
behaviour is always a bit of a problem but to the best of my knowledge
enabling fragmentation is a bug in any and all real-world applications.


Richard
