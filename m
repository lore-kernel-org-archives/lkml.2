Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2E3KWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:22:32 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:2581 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab2E3KWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:22:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAX0xU/CTtAn/2dsb2JhbABEtASBB4IXAQEFOj8QCxguFBgxE4gPuTiLBYRiYAOVFwGJHoZUgmI
Date: Wed, 30 May 2012 12:22:26 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
	and strnlen_user()
Message-ID: <20120530102226.GA28628@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Do we also want
> 
>     select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE && !M68000)

Sorry, I did not follow what happened to unaligned accesses, but
CPU32 family (at least 68340) crashes on unaligned accesses.

Philippe
