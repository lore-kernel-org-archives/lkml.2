Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2HASAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:00:42 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:40822 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754704Ab2HASAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:00:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WxT_8XQVM1nbwe5410xgqsXmAoA76aTLoiLz52ohTQuAZ4Z
 VV8479CCAlx5KiMtu6oMSX9SYcaljPcKPerag.L5xcIbbTVMxbQbxFUvQEKS
 Nb0KLz3OGAcGk1BgMt69IJACq7bPhFbf1vSpdbfAILEZ48tyThqosEyPyGGD
 Yec6UVp8l0WIZUIA6yv0ZX2Y3qjvmTNJOJ3TZNRnITgR3nN9FtnDMqbw_W0B
 JWpneNmrREsiXp7lw1fUh7lfJbBPEKycW1fXY7EkzVo4PyLuwjBAIxwXfjkT
 QyflFtVJZjQlO5INgl6KNDbvZRZbXcBo0_8JN2aBoYSYWTKZCWCoyjtW.44g
 bLWCjGTTJagm44fzAP3F2zCNce1pdFAoB1LF.io9hm8XIGM6qHhKRXKgFB2k
 YCkAWP0INaqwMPtK8TVytU60y5O.tk9z2CK7Sz1TauK134jAuDw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 1 Aug 2012 13:00:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: JoonSoo Kim <js1304@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Brice Goglin <brice@myri.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [RESEND PATCH 4/4 v3] mm: fix possible incorrect return value
 of move_pages() syscall
In-Reply-To: <CAHO5Pa0wwSi3VH1ytLZsEJs99i_=5qN5ax=8y=uz1jbG+P03sw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1208011259550.4606@router.home>
References: <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-4-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207271550190.25434@router.home> <CAAmzW4MdiJOaZW_b+fz1uYyj0asTCveN=24st4xKymKEvkzdgQ@mail.gmail.com>
 <alpine.DEB.2.00.1207301425410.28838@router.home> <CAHO5Pa0wwSi3VH1ytLZsEJs99i_=5qN5ax=8y=uz1jbG+P03sw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1208011259552.4606@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Michael Kerrisk wrote:

> Is the patch below acceptable? (I've attached the complete page as well.)

Yes looks good.

> See you in San Diego (?),

Yup. I will be there too.


