Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1GGTOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:14:19 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:34675 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751306Ab1GGTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:14:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ca6W61oVM1kg23UpA_BE5xXbAWjxkQD25Ye5M5pNNDRtF3v
 Hl8tsQWQfudoRENJyX8B5L4uOzx4g6vRfEj4hREC8wiXe39haBj65AkO6VkS
 TPh1R8nFGCLo7yrr587eKmi42sivKJjcbuvXHCNzLHK25kLUJVR2zMBq0cX0
 FO28TvD9GLkRSmWQQdiehp_jkZcNGAF22HZpAKocouLXiu0PgBJkqsTZXF32
 B8rJEJOO2wYR6K8mtlVjte...Rf2bfJf0pGzr5zrTBtNt2Rv6FKrBFyoZC78
 3MK7v6AIExvRf07_e854sj.sCc747UvDx_KuCc1Lzho.ia85CcHrUWZ0YoNd
 TB0Q4FOSTXWT89Z9QWaW5Tt8f
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 14:14:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: piotr@hosowicz.com, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
In-Reply-To: <1310065670.21902.62.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1107071413290.24437@router.home>
References: <4E143120.2020501@cam.ac.uk>  <alpine.DEB.2.00.1107060933460.17202@router.home>  <4E15AF1C.7080103@example.com>  <alpine.DEB.2.00.1107070841500.17376@router.home>  <4E15B945.5060805@example.com> <1310065670.21902.62.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Pekka Enberg wrote:

> > I attach it. Your patch seems to had worked, I finish making the package.
>
> I'm confused. Does Christoph's patch fix the problem for everyone?

Guess so (heard nothing to the contrary) but I still would like to know
what caused it. My best guess right now its gccs 4.6s stricter checking.

