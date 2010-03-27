Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0C0E6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 00:58:46 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:43757 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0C0E6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Sxp/21Qv2z9RF0mafMJOAKWTnptT3YFToY9M4yM1b/DYzg6PjWdWqd/YrwmT7V7kdU
         SBOf027dzjv//KqpxW+yPwMqs0MWkt47odJUK9dnrq7Dd1WE4Mpc1X6RNGx5GTn3o71q
         A8fRTKhdo39O5YmLMKJbLGkqjZhUKk7n67RsE=
MIME-Version: 1.0
In-Reply-To: <20100327021803.GA10866@xpc.home>
References: <20100326223530.GA11817@xpc.home> <1269643470.2256.17.camel@edumazet-laptop> 
	<84621a61003261555q2c78f6a8o5b438113bed6bd2@mail.gmail.com> 
	<a36005b51003261907x7ebe057bt2d541f63f20f632b@mail.gmail.com> 
	<20100327021803.GA10866@xpc.home>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 26 Mar 2010 21:58:24 -0700
Message-ID: <a36005b51003262158q32e47244vf9585aae335ac56b@mail.gmail.com>
Subject: Re: [PATCH v2] Add MSG_WAITFORONE flag to recvmmsg
To: Brandon L Black <blblack@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 19:18, Brandon L Black <blblack@gmail.com> wrote:
> Add new flag MSG_WAITFORONE for the recvmmsg() syscall.
> When this flag is specified for a blocking socket, recvmmsg()
> will only block until at least 1 packet is available.  The
> default behavior is to block until all vlen packets are
> available.  This flag has no effect on non-blocking sockets
> or when used in combination with MSG_DONTWAIT.
>
> Signed-off-by: Brandon L Black <blblack@gmail.com>

This is useful and looks OK to me.

Acked-by: Ulrich Drepper <drepper@redhat.com>
