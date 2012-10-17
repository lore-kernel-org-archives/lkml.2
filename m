Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2JQPm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:42:57 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6830 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:42:56 -0400
Message-ID: <507ED1FE.4070506@tilera.com>
Date: Wed, 17 Oct 2012 11:42:54 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <torvalds@osdl.org>, <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 05/10] UAPI: Place comments in empty arch Kbuilds to make
 them non-empty
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk> <20121017141558.29084.64892.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141558.29084.64892.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 10:15 AM, David Howells wrote:
> Place comments in:
>
> 	arch/mips/include/asm/Kbuild
> 	arch/tile/include/arch/Kbuild
>
> to make them non-empty so that the patch program doesn't remove them when it
> reduces them to nothing.
>
> Possibly they should be just deleted, but it's possible that they'll acquire
> generic-y or genhdr-y lines in future, so I'm keeping them around for the
> moment.
>
> Note that MIPS will compile happily if the file is deleted instead.  I haven't
> tested TILE, but I suspect it will be the same there.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Ralf Baechle <ralf@linux-mips.org>
> cc: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

