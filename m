Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2DRRgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:36:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51220 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DRRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:36:52 -0400
Date: Wed, 18 Apr 2012 19:36:49 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
Message-ID: <20120418173649.GB6165@x4>
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
 <4F8DF90B.1090002@xenotime.net>
 <20120418194055.2d929e58@tukaani.org>
 <4F8EEFB5.8040604@zytor.com>
 <20120418200929.086ce3a7@tukaani.org>
 <20120418172349.GA6165@x4>
 <4F8EF9E3.7030801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8EF9E3.7030801@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.04.18 at 10:29 -0700, H. Peter Anvin wrote:
> On 04/18/2012 10:23 AM, Markus Trippelsdorf wrote:
> > 
> > When btrfs will finally implement LZ4 compression this would be the obvious
> > candidate for the fastest boot algo, because its decompression speed is
> > amazing.
> > 
> 
> Uh, no (and what does btrfs have to do with anything here?)

I was referring to a possible library implementation.

> The issue is that the ratio of I/O speed to CPU can mean that a slower
> decompression algorithm with better compression can still win,
> time-wise, if your media is slow and your CPU is fast.

Sure. Only measurements will tell...

-- 
Markus
