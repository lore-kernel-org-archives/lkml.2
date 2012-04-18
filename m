Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2DRQlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:41:12 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:54690 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2DRQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:41:10 -0400
Date: Wed, 18 Apr 2012 19:40:55 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com, hpa@zytor.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
Message-ID: <20120418194055.2d929e58@tukaani.org>
In-Reply-To: <4F8DF90B.1090002@xenotime.net>
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
	<4F8DF90B.1090002@xenotime.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-17 Randy Dunlap wrote:
> There have been new compression algorithms added without
> updating nearby relevant descriptive text that refers to
> (a) the number of compression algorithms and (b) the most
> recent one.  Fix these inconsistencies.

It could also be good to fix which algo has the best compression ratio.
XZ supports BCJ filters on some archs and on those it will give a few
percent smaller kernel than LZMA. Without BCJ, XZ and LZMA are
practically tied.

If you feel like it, maybe it would be nice to have some
recommendations in the descriptions:
  - gzip is a safe choice if unsure what to do.
  - XZ is good when small size is important (embedded systems,
    live CDs).
  - LZO should give the fastest boot from a hard disk (desktop systems
    where file size doesn't matter much).

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
