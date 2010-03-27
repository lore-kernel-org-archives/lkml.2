Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0C0DyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 23:54:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57698
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab0C0DyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 23:54:05 -0400
Date: Fri, 26 Mar 2010 20:54:28 -0700 (PDT)
Message-Id: <20100326.205428.44779758.davem@davemloft.net>
To: blblack@gmail.com
Cc: netdev@vger.kernel.org, acme@redhat.com, drepper@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add MSG_WAITFORONE flag to recvmmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100327021803.GA10866@xpc.home>
References: <84621a61003261555q2c78f6a8o5b438113bed6bd2@mail.gmail.com>
	<a36005b51003261907x7ebe057bt2d541f63f20f632b@mail.gmail.com>
	<20100327021803.GA10866@xpc.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon L Black <blblack@gmail.com>
Date: Fri, 26 Mar 2010 21:18:03 -0500

> 
> From: Brandon L Black <blblack@gmail.com>
> 
> Add new flag MSG_WAITFORONE for the recvmmsg() syscall.
> When this flag is specified for a blocking socket, recvmmsg()
> will only block until at least 1 packet is available.  The
> default behavior is to block until all vlen packets are
> available.  This flag has no effect on non-blocking sockets
> or when used in combination with MSG_DONTWAIT.
> 
> Signed-off-by: Brandon L Black <blblack@gmail.com>

Arnaldo, please review this, thanks.
