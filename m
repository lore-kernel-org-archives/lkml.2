Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0JLT2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:28:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46527
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab0JLT2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:28:22 -0400
Date: Tue, 12 Oct 2010 12:28:41 -0700 (PDT)
Message-Id: <20101012.122841.183039561.davem@davemloft.net>
To: awalls@md.metrocast.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, kaber@trash.net
Subject: Re: [PATCH] IPv4: Remove check for ipv4_is_lbcast() that will
 always return false
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286727021.2435.17.camel@localhost>
References: <1286727021.2435.17.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 10 Oct 2010 12:10:21 -0400

> In making an IPv4 routing decision, packets with an all 1's broadcast
> destination are accepted as input packets, before being checked for being a
> martian.  Remove the martian check for the all 1's broadcast destination
> address.  Make the initial check for the all 1's broadcast destination
> address easier to read.
> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Your email client corrupted this patch, by turning tab characters
into spaces, amongst other things.

Please give Documentation/email-clients.txt a read and resubmit this
patch after you have these issues sorted out.

Thank you.
