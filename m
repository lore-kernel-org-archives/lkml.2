Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab0EYBu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:50:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab0EYBu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:50:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kGoabzFAr4GwyFdmN70C9L7pDW8jIDe09HWHyVZiv+tHus54tWWZNog5nofr3+CJZ
	cwN7wFTg3CX9bBTvAzu7w==
MIME-Version: 1.0
In-Reply-To: <20100524231815.713224572@clark.site>
References: <20100524231840.GA17857@kroah.com>
	<20100524231815.713224572@clark.site>
Date: Mon, 24 May 2010 18:50:20 -0700
Message-ID: <AANLkTilMq6zUgCus6_suEjAcTPYY7Ao0gCvrWHkTe9F6@mail.gmail.com>
Subject: Re: [28/39] x86, cacheinfo: Turn off L3 cache index disable feature 
	in virtualized environments
From: Hugh Dickins <hughd@google.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 4:15 PM, Greg KH <gregkh@suse.de> wrote:
>
> 2.6.33-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
> From: Frank Arnold <frank.arnold@amd.com>
>
> commit 7f284d3cc96e02468a42e045f77af11e5ff8b095 upstream.

Closer, but aren't all the XX/34s intended for 2.6.32.14, not 2.6.33.5?

I'm trying to check whether my kernel/profile.c fix (18/34) is in for
both 2.6.32.14 and 2.6.33.5, but getting too confused to tell!

Hugh
