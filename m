Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2FUTy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:54:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44457 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2FUTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:54:55 -0400
Message-ID: <4FE37C0E.8050306@tilera.com>
Date: Thu, 21 Jun 2012 15:54:54 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Michal Marek <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        Richard Kuo <rkuo@codeaurora.org>, <linux-hexagon@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, <linux-am33-list@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Remove useless wrappers of asm-generic/ipc.h
References: <1340306466.1773.60.camel@x61.thuisdomein>
In-Reply-To: <1340306466.1773.60.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2012 3:21 PM, Paul Bolle wrote:
> mn10300 has a header (in its include/asm directory) that is a thin
> wrapper around asm-generic/ipc.h. This wrapper is useless, since that
> header doesn't exist. It is also unused (no file includes asm/ipc.h).
>
> hexagon and tile generate similar headers at build time (using a
> generic-y entry in include/asm/Kbuild). These generated headers are
> useless and unused too.
>
> Remove this header and these generic-y entries.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/hexagon/include/asm/Kbuild |    1 -
>  arch/mn10300/include/asm/ipc.h  |    1 -
>  arch/tile/include/asm/Kbuild    |    1 -
>  3 files changed, 0 insertions(+), 3 deletions(-)
>  delete mode 100644 arch/mn10300/include/asm/ipc.h

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

I can queue the tile change if you'd like; otherwise I assume you'll push
this whole commit.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



