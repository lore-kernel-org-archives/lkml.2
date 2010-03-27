Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0C0P2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:28:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58766
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0C0P2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:28:46 -0400
Date: Sat, 27 Mar 2010 08:29:10 -0700 (PDT)
Message-Id: <20100327.082910.71119369.davem@davemloft.net>
To: acme@redhat.com
Cc: blblack@gmail.com, netdev@vger.kernel.org, drepper@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add MSG_WAITFORONE flag to recvmmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100327140717.GN3625@ghostprotocols.net>
References: <20100327021803.GA10866@xpc.home>
	<20100326.205428.44779758.davem@davemloft.net>
	<20100327140717.GN3625@ghostprotocols.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Sat, 27 Mar 2010 11:07:17 -0300

> Em Fri, Mar 26, 2010 at 08:54:28PM -0700, David Miller escreveu:
>> From: Brandon L Black <blblack@gmail.com>
>> Date: Fri, 26 Mar 2010 21:18:03 -0500
>> 
>> > 
>> > From: Brandon L Black <blblack@gmail.com>
>> > 
>> > Add new flag MSG_WAITFORONE for the recvmmsg() syscall.
>> > When this flag is specified for a blocking socket, recvmmsg()
>> > will only block until at least 1 packet is available.  The
>> > default behavior is to block until all vlen packets are
>> > available.  This flag has no effect on non-blocking sockets
>> > or when used in combination with MSG_DONTWAIT.
>> > 
>> > Signed-off-by: Brandon L Black <blblack@gmail.com>
>> 
>> Arnaldo, please review this, thanks.
> 
> I'm ok with it.
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Applied, thanks everyone.
