Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2ENNpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:45:10 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:31826 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754905Ab2ENNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:45:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vA.iMWIVM1na7ZIN97RoLKfs.Lk8.p_eDwWjEQRXCYhVaFg
 rjo01.wtnd9QctISNL2gkLtVQM2T6tpHTnNjJ4P8P77_K9duMkatecGJR2ii
 Hm5L4UBxEfFlSRTHt406uX9Dqeb30l.CT3DT_JFSoEuvvswcMM2Fm.6_mcuU
 0uJRJ7avvr27EfZOclQ09spsjFAq6sgvfLLCGpE6hRgFL2SDtVFZl6KQJiTO
 eZGHokoP7MupUi9E5vkgVbk2Z2zJxugQh7p1wt_obqFHOpwKgLYTdaxql6Gl
 w8DS3QvY.Z3CRNoGP.UTOl2tbwpbWOOxtYzxIKEA4KgW6_vFPNV1BEz9Jj.J
 Nqd9yZfaVI9eCwFqIuy_GZvfB5UV9BuaBl.UMQKlYlEvKY.23x_ohiXUw2DL
 P0PtW92CCrxH5BwDj3aC_0dJwdwZXTEMzbSI-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 14 May 2012 08:45:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: majianpeng <majianpeng@gmail.com>
cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-mm <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH] slub: missing test for partial pages flush work in
 flush_all
In-Reply-To: <201205140909294844918@gmail.com>
Message-ID: <alpine.DEB.2.00.1205140844490.26056@router.home>
References: <201205111008157652383@gmail.com>, <alpine.DEB.2.00.1205111113460.31049@router.home> <201205140909294844918@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, majianpeng wrote:

> Sorry for late to relay. I rewrited the comment and resend.
> I have a question to ask:because the patch fixed by others,for example Christoph Lameter, Gilad.
> Should I add sogine-off by them in the patch?

I 6hink its fine the way it is.

