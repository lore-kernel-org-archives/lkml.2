Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2DRR33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:29:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40553 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2DRR32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:29:28 -0400
Message-ID: <4F8EF9E3.7030801@zytor.com>
Date: Wed, 18 Apr 2012 10:29:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Lasse Collin <lasse.collin@tukaani.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com> <4F8DF90B.1090002@xenotime.net> <20120418194055.2d929e58@tukaani.org> <4F8EEFB5.8040604@zytor.com> <20120418200929.086ce3a7@tukaani.org> <20120418172349.GA6165@x4>
In-Reply-To: <20120418172349.GA6165@x4>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 10:23 AM, Markus Trippelsdorf wrote:
> 
> When btrfs will finally implement LZ4 compression this would be the obvious
> candidate for the fastest boot algo, because its decompression speed is
> amazing.
> 

Uh, no (and what does btrfs have to do with anything here?)

The issue is that the ratio of I/O speed to CPU can mean that a slower
decompression algorithm with better compression can still win,
time-wise, if your media is slow and your CPU is fast.

	-hpa

