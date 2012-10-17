Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2JQPnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:43:12 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6836 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab2JQPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:43:10 -0400
Message-ID: <507ED20D.3010605@tilera.com>
Date: Wed, 17 Oct 2012 11:43:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <torvalds@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] UAPI: The tile arch uses the generic ucontext.h
 file
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk> <20121017141605.29084.34012.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141605.29084.34012.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 10:16 AM, David Howells wrote:
> Move the header-y and generic-y lines for ucontext.h from
> arch/tile/include/asm/Kbuild to the uapi/ Kbuild as the asm-generic variant is
> used.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

