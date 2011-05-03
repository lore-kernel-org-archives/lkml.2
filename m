Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1ECWW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:22:29 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:43108 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1ECWW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:22:28 -0400
From: Lasse Collin <lasse.collin@tukaani.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] XZ decompressor: Fix decoding of empty LZMA2 streams
Date: Wed, 4 May 2011 01:22:36 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.38-ARCH; KDE/4.6.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
References: <201105011938.42851.lasse.collin@tukaani.org> <20110503143620.c6b4d272.akpm@linux-foundation.org>
In-Reply-To: <20110503143620.c6b4d272.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105040122.36545.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-04 Andrew Morton wrote:
> Lasse Collin <lasse.collin@tukaani.org> wrote:
> > From: Lasse Collin <lasse.collin@tukaani.org>
> > 
> > The old code considered valid empty LZMA2 streams to be corrupt.
> > Note that a typical empty .xz file has no LZMA2 data at all,
> > and thus most .xz files having no uncompressed data are handled
> > correctly even without this fix.
> > 
> > Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
> 
> The patch didn't have the cc:stable tag, but appears to be needed in
> 2.6.38.x and perhaps earlier, yes?
> 
> It's commit 646032e3b05b32d3f20cb108a030593d9d792eb5 in mainline.

Thanks. It's good for 2.6.38.x. Older ones don't have XZ support.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
