Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2K0BYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:24:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50938 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab2K0BYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:24:04 -0500
X-AuditID: cbfee611-b7f2f6d000000d5b-c0-50b416327bd4
Date: Tue, 27 Nov 2012 01:24:02 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20121127012315310@jg1.han
Msgkey: 20121127012315310@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121127012315310@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8716524.45681353979440603.JavaMail.weblogic@epv6ml07>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zY10jsS0BBsfbxSwu75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmHLp0n7XgGUfF6j8bmBsYj3B0MXJyCAkoSUw6uZcRxJYQMJF4/347
	G4QtJnHh3nogmwuoZhmjxNwfP9lhig5+X8ME0TyfUaJnXwmIzSKgKnHpwj1mEJtNQF1iwu9m
	FhBbWMBZYurdb2C9IgJWElMarjCBDGUW6GWR+L/mL9QgWYl7k2eDNfMKCEqcnPmEBWKZgsSp
	7udQcUWJ5gsvmSDiEhJ37u9nhbB5JWa0P4Wql5OY9nUNM4QtLXF+1gZGmG8Wf38MFeeXOHZ7
	B9AcDrDeJ/eDYcbs3vwF6nkBialnDkK1qkrMm/QPyuaTWLPwLdQqQYnT17qZYXobNv4G+5EZ
	6Mwp3Q+hbC2JLz/2saF7i1fASaL51mvGCYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6anm
	yLG9iRGSCAV3MC5tsDjEKMDBqMTDq7Buc4AQa2JZcWXuIUYJDmYlEd5pbFsChHhTEiurUovy
	44tKc1KLDzFOZARG4URmKdHkfGCaziuJNzQ2NjEzMTUxtzQ1NyVG2NzI1ACYgg0MSRRWEufl
	rJgeICSQnliSmp2aWpBaBHMUEwenVANjFov3nw86h3nX6G8LYgyVUi36W+u1r6BOY+sKyRVd
	Bn+m6b09qxNjZPz8z7LWlMNyG/henAnmu39P8PWCjEdvzPZeOfvLpeq3OudhO8c7lnqbpwd8
	m5Uk5vIrz+/xj299Ka+2ObeLL9684tH6wMYraffnNK67ePuAyN9vYiaqHi/Y7yTE7vc9q8RS
	nJFoqMVcVJwIAG2faKT3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t/tGbpGYlsCDF5e4be4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GYcu3WcteMZRsfrPBuYGxiMcXYycHEICShKTTu5lBLElBEwkDn5fwwRhi0lcuLeeDaJmPqNE
	z74SEJtFQFXi0oV7zCA2m4C6xITfzSwgtrCAs8TUu9/YQWwRASuJKQ1XgOZwcTAL9LJI/F/z
	lwlikKzEvcmzwZp5BQQlTs58wgKxTEHiVPdzqLiiRPOFl1BHSEjcub+fFcLmlZjR/hSqXk5i
	2tc1zBC2tMT5WRsYYY5e/P0xVJxf4tjtHUBzOMB6n9wPhhmze/MXNghbQGLqmYNQraoS8yb9
	g7L5JNYsfAu1SlDi9LVuZpjeho2/wX5kBjpzSvdDKFtL4suPfWzo3uIVcJJovvWacQKj3Cwk
	qVlI2mchaUdWs4CRZRWjaGpBckFxUnqquV5xYm5xaV66XnJ+7iZGcIp6JriDcWmDxSFGAQ5G
	JR5ehXWbA4RYE8uKK3MPMUpwMCuJ8E5j2xIgxJuSWFmVWpQfX1Sak1p8iNEHGIMTmaVEk/OB
	6TOvJN7Q2NjEzMTU3MDCwNIch7CSOC9nxfQAIYH0xJLU7NTUgtQimHFMHJxSDYzhVfISk/qV
	Co48vRtjkjdl/guXS5wS2w9aXu3Vu3FE48Wcbf7iLaa/v+6eVnYukGPC4p1bWf87z/M5+kpB
	2qz3c6OEmu8bDb2aP6YfzyVW3khPnpT2KLMzblq7T3K+1v6vboWVduWdUxK2yv8vu559LWCv
	zZFpne3zGzasWSy5mu1wdcoTvvtKLMUZiYZazEXFiQBdvw29fgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAR1ODvD030125

On Monday, November 26, 2012 7:25 PM, Laurent Pinchart wrote
> 
> Hi Jingoo,
> 
> On Monday 26 November 2012 09:49:36 Jingoo Han wrote:
> > On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> > >
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
> > CC'ed Andrew Morton
> >
> > It looks good. Also, I tested this patch with SMDK4210 board.
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> Thank you.
> 
> Unless Richard wants to take 1/5 and 2/5, I plan to push them through either
> the Renesas ARM or Renesas SH tree with the board code patches.

Hi Laurent,

OK, I see.
Maybe Richard won't take 1/5 and 2/5. As you mentioned, it would be good
to push them throughout the Renesas tree to avoid bisection breakages.

Best regards,
Jingoo Han


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
