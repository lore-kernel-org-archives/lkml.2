Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281Ab2KAVUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:20:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59287 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2KAVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:20:50 -0400
From: maillist@superlative.org
To: Daniel Mack <zonque@gmail.com>
Cc: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Idea: dynamic loading of USB quirks
Date: Thu, 01 Nov 2012 21:20:46 +0000
Message-ID: <1410076.LzJ0gmvzpA@kamdesktop>
User-Agent: KMail/4.8.5 (Linux/3.2.0-23-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50923B65.4060304@gmail.com>
References: <2390628.MpxcLPPhM0@kamdesktop> <50923B65.4060304@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 Nov 2012 10:05:41 Daniel Mack wrote:
> [cc lkml as this might be of broader interest]
> 

> 
> Then again, if a versatile and clean solution to this problem is found,
> there would be tons of other drivers in Linux to benefit from it, just
> think about the hda driver to begin with. But not only in the ALSA area.
>

I was initially thinking of the more trivial USB quirkes only, and having the 
more complex quirks remain as hard coded.

But it does make sense that, if such a capability could be extended, that it 
could be used for other drivers too.

Cheers,

Keith
