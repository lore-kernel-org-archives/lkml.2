Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0EQPec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:34:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0EQPe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:34:29 -0400
Date: Mon, 17 May 2010 17:34:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Anirban Sinha <asinha@zeugmasystems.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] Tidy REMOTE_DEBUG
In-Reply-To: <20100517152554.GB3686@faui49.informatik.uni-erlangen.de>
Message-ID: <alpine.LNX.2.00.1005171733430.28092@pobox.suse.cz>
References: <20100517152554.GB3686@faui49.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Christoph Egger wrote:

> >From 7cc3dbcc665505816368268dee33f6f54d97fc84 Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@cs.fau.de>
> Date: Mon, 17 May 2010 17:21:02 +0200
> Subject: [PATCH 2/2] Remove CONFIG_REMOTE_DEBUG
> 
> REMOTE_DEBUG does already appear in 2.2 kernel sources but didn't
> appear as a config Option in the initial git import 2.6.12-rc. It's
> currently just used in one single place of the linux kernel and should
> probably be dropped totally
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  drivers/char/serial167.c |  223 +---------------------------------------------
>  1 files changed, 1 insertions(+), 222 deletions(-)

While you are at it, you could probably nuke the references in 
arch/frv/kernel/gdb-stub.c and arch/mn10300/kernel/gdb-stub.c as well ...

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
