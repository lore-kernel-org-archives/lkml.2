Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1BVCNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:13:30 -0500
Received: from ozlabs.org ([203.10.76.45]:32774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab1BVCN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:13:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: remove 64 bit alignment padding from struct module with CONFIG_TRACE*
In-Reply-To: <1298296661.2084.6.camel@castor.rsk>
References: <1298296661.2084.6.camel@castor.rsk>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 22 Feb 2011 12:25:34 +1030
Message-ID: <87pqqku92h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 13:57:41 +0000, Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> Reorder struct module to remove 24 bytes of alignment padding on 64 bit
> builds when the CONFIG_TRACE options are selected. This allows the
> structure to fit into one fewer cache lines, and its size drops from 592
> to 568 on x86_64.

Thanks, applied.

Cheers,
Rusty.
