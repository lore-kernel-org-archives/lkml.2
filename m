Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2EQQH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:07:57 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24561 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751157Ab2EQQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:07:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zOq0tm8VM1lb1LEUUklzv9hveDLfVbAICnOh6Q0Tu_DESnP
 rRrivAKPXJSl.BZkDjvFBx7R30Dpr_RqCeGH0ySdHtfcTrkEkgoBGXh8WWJm
 t_yS5SE_b2VixavERLMNP6S_OCfCcKTIXmD7CxDBGht7z5_bPjn38121i0ki
 335cedvUy2iqZ8KRJEMntMXARVCchdynTc_AGCBuOhgNta7Bf5hwt8A9fiRq
 nJpe2guiaAiTAwIXqWDwsFW8JuoygFcAry.itKlx4vc5hdn_OGSx9bwRb_zS
 JRlq.XkN_OJUlmtyQydqEJQCv0sEgLMUCP99mBIqf4zd4eO8KiYfjGbVqBMm
 YmeCiUYV__E5ll6imsca4vJyRD4xc7kUOQTsG1MK0nNwUzYlDkwQ2rqd50hY
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 17 May 2012 11:07:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/4] slub: use __SetPageSlab function to set PG_slab
 flag
In-Reply-To: <1337269668-4619-4-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205171107360.5144@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337269668-4619-4-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> To set page-flag, using SetPageXXXX() and __SetPageXXXX() is more
> understandable and maintainable. So change it.

Acked-by: Christoph Lameter <cl@linux.com>
