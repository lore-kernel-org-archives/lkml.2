Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2DRRJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:09:43 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:31314 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2DRRJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:09:42 -0400
Date: Wed, 18 Apr 2012 20:09:29 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
Message-ID: <20120418200929.086ce3a7@tukaani.org>
In-Reply-To: <4F8EEFB5.8040604@zytor.com>
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
	<4F8DF90B.1090002@xenotime.net>
	<20120418194055.2d929e58@tukaani.org>
	<4F8EEFB5.8040604@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-18 H. Peter Anvin wrote:
> On 04/18/2012 09:40 AM, Lasse Collin wrote:
> >   - LZO should give the fastest boot from a hard disk (desktop
> >     systems where file size doesn't matter much).
> 
> That really depends on the speed of your disk vs CPU.

Yes. Maybe it isn't good to give so clear recommendation for LZO over
gzip here.

I think it is still safe to say that gzip and LZO are better than
bzip2, XZ, or LZMA for compressing a kernel that will be loaded from a
normal hard disk. It would be unusual if reading the disk was so slow
that e.g. XZ would make the booting faster than gzip.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
