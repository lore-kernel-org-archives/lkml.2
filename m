Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2L0TDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 14:03:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41082 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab2L0TDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 14:03:53 -0500
Date: Thu, 27 Dec 2012 20:03:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
Message-ID: <20121227190351.GA10819@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121227185126.GA10207@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121227185126.GA10207@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 07:51:26PM +0100, Borislav Petkov wrote:
> > commit bb3cda32f9586e13c5d3dde6c83a914bb2d7f87f
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Mon Dec 24 18:00:21 2012 -0800
> > 
> >     x86, mm: add generic kernel/ident mapping helper
> >     
> >     It is simple version for kernel_physical_mapping_init.
> >     it will work to build one page table that will be put effectiv later.

Forgot to ask: what does "put effectiv later" mean?

* will be effectively put to use later

* will effectively be put, i.e. dropped later

* we will switch to using it later

* ...

Thanks.

-- 
Regards/Gruss,
Boris.
