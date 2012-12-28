Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2L1Lj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:39:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38671 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2L1Lj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:39:26 -0500
Date: Fri, 28 Dec 2012 12:39:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
Message-ID: <20121228113925.GA12363@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121227185126.GA10207@x1.alien8.de>
 <CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
 <CAE9FiQXgDGBsCHPC2m4mDx4JxgKu5tJ0ABMY2jch-1=JUdnm4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXgDGBsCHPC2m4mDx4JxgKu5tJ0ABMY2jch-1=JUdnm4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:13:06AM -0800, Yinghai Lu wrote:
> so will stay with alloc.

"alloc" is too generic. So call it 'get_one_pgt_page' or
'alloc_pgt_page' or something descriptive to say what it does than
simply 'alloc'. 'alloc' can be anything - it could mean allocation hints
or flags or whatever you feel like at that particular time of day :-).

Thanks.

-- 
Regards/Gruss,
Boris.
