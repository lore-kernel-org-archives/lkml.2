Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2A3SiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:38:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38122 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2A3SiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:38:03 -0500
MIME-Version: 1.0
In-Reply-To: <4F26CD48.3040809@gmail.com>
References: <0736d2becb10905c35eec74f04c63970@localhost>
	<4F26CD48.3040809@gmail.com>
Date: Mon, 30 Jan 2012 10:38:02 -0800
Message-ID: <CAJiQ=7DXJvnt0NZLiThiH+FiQ43GTm07ODJs6e4-RbpsBSxAKQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix duplicate instances of ARCH_SPARSEMEM_ENABLE
From: Kevin Cernekee <cernekee@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>, viric@viric.name
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 9:03 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> NAK!
>
> A cleaner patch for this was already done here:
>
> http://patchwork.linux-mips.org/patch/3285/

This patch fixed the problem for me, but it doesn't apply cleanly to
the current head of tree since the context (CAVIUM_OCTEON_HELPER) has
changed.

Lluis, do you want to go ahead and submit a V2?

Thanks.
