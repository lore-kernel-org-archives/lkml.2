Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2DYVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:44:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:38191 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757827Ab2DYVo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:44:27 -0400
Message-ID: <1335390257.21961.53.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 26 Apr 2012 07:44:17 +1000
In-Reply-To: <4F98117C.7080309@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 10:00 -0500, Larry Finger wrote:
> 
> After a few tries, I managed to change over to pata_macio.
> Fortunately, most of 
> the system used dev-by-id or UUID, thus most of the process was
> getting all the 
> kernel pieces built in.
> 
> Unfortunately, the original problem remains. I have resumed the
> bisecting - only 
> 11 steps to go. I should have it by Friday! :)
> 
Thanks !

Do we know what the bad interrupt maps to ? Also what is the value of
NR_IRQ and do you have SPARSE_IRQ enabled ? Can you try with the latter
disabled and NR_IRQ set to something large, such as 128 ?

(You may be able to check the interrupt mapping in debugfs)

Cheers,
Ben.


