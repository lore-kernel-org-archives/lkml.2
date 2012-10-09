Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2JIRza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:55:30 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:26643 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2JIRz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:55:28 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzAuK2Ta6k=
X-RZG-CLASS-ID: mo00
Message-ID: <50746516.6040100@hartkopp.net>
Date: Tue, 09 Oct 2012 19:55:34 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: David Howells <dhowells@redhat.com>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for can
References: <30687.1349789402@warthog.procyon.org.uk>
In-Reply-To: <30687.1349789402@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marc,

can you please pull these changes, so that they can go via the CAN tree to Dave?

Thanks,
Oliver

On 09.10.2012 15:30, David Howells wrote:

> Can you merge the following branch into the can tree please.
> 
> This is to complete part of the Userspace API (UAPI) disintegration for which
> the preparatory patches were pulled recently.  After these patches, userspace
> headers will be segregated into:
> 
> 	include/uapi/linux/.../foo.h
> 
> for the userspace interface stuff, and:
> 
> 	include/linux/.../foo.h
> 
> for the strictly kernel internal stuff.
> 
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-can-20121009
> 
> for you to fetch changes up to c523b9b41d6bfdd035b5c25063ad13967f3306cd:
> 
>   UAPI: (Scripted) Disintegrate include/linux/can (2012-10-09 09:48:41 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate include/linux/can
> 
>  include/linux/can/Kbuild               | 5 -----
>  include/uapi/linux/can/Kbuild          | 5 +++++
>  include/{ => uapi}/linux/can/bcm.h     | 0
>  include/{ => uapi}/linux/can/error.h   | 0
>  include/{ => uapi}/linux/can/gw.h      | 0
>  include/{ => uapi}/linux/can/netlink.h | 0
>  include/{ => uapi}/linux/can/raw.h     | 0
>  7 files changed, 5 insertions(+), 5 deletions(-)
>  rename include/{ => uapi}/linux/can/bcm.h (100%)
>  rename include/{ => uapi}/linux/can/error.h (100%)
>  rename include/{ => uapi}/linux/can/gw.h (100%)
>  rename include/{ => uapi}/linux/can/netlink.h (100%)
>  rename include/{ => uapi}/linux/can/raw.h (100%)
> .
> --
> To unsubscribe from this list: send the line "unsubscribe linux-can" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


