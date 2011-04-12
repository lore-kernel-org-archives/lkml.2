Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab1DLSCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:02:23 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:31251 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755665Ab1DLSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:02:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uxgMC_kVM1njLS7pyCPu5xmePxg48cmGE.2PZGWFv0qXTPp
 YfnxxpQCz.4BMtrWLFEBLENwIo8xyDa7YM.tgh_7ZColfsDWyaOew77MFMc9
 pAE7Bt6WKpHRjPPXUpfH9LgleRMbWyuIFH8l_GHuKAQongz6rOulCNnpl1V.
 g608rISiZBRbAJv4HCRjzPeeMLe.mxB_0P2Okz0YIBCNtw.8TQmfWPsGOsZx
 YiYRWmfa1dXA27fAHQXqxbwllrY1EnRXGhpONeBKTMKzfLdC_4AwrbRJXoLE
 .Hm6dXJN4DiX0lH.vrUGjsLmh_SpdxsY23eN7C0E2LIcbYznRD5JSFi9W6Lq
 783BNuaM2rjn4EIFitlRGo8E-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Apr 2011 13:02:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, penberg@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Fix a typo in config name
In-Reply-To: <4DA3FDB2.9090100@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104121301430.14692@router.home>
References: <4DA3FDB2.9090100@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Li Zefan wrote:

> There's no config named SLAB_DEBUG, and it should be a typo
> of SLUB_DEBUG.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>
> not slub expert, don't know how this bug affects slub debugging.

Affects the bootstrap code.

Acked-by: Christoph Lameter <cl@linux.com>
