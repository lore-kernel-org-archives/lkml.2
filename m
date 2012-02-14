Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976Ab2BNPHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:07:50 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:26595 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756667Ab2BNPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:07:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GieEOUsVM1lJFgVfHpOdg1_GFn.K4LeVLy8qAM5tiFq523q
 DPWMkHF6fDdrpvtheCEM97borL.ztEB9GFZGbPAKuKOtoApLao_eiEpfzm9S
 eph2MXMNItKv9WpjuZpMMf6XhBs2XpZAC2EoXnJq_7..ofFzftOSU0I7dC5V
 5NkA6evSMP_l48huoYcSUTPMIfHN2mXhAnuY7l_uSfcjhLClzxuX.xabZ2aK
 MJ0sIU5tIatckcuWLDP6x1_.OaR2ZKez1B8NHWB1Moo7wwiDioi1qIzUx2gW
 otBazDlCrNHCD2ItLDsxnB1vsRRKT1n4YwF4lpHbNgb5RpxQcnYtOD0KsXJW
 HaxZaKIVvcKci0vs.f2h0ghsJbzgQPod_mnz2yYhUejieDOmaibxLfktSd3m
 Q
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 09:07:44 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yang Bai <hamo.by@gmail.com>, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
In-Reply-To: <20120214005301.a9d5be1a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1202140906500.20013@router.home>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com> <20120214005301.a9d5be1a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Andrew Morton wrote:

> One of the applications of kcalloc() is to prevent userspace from
> causing a multiplicative overflow (and then perhaps causing an
> overwrite beyond the end of the allocated memory).
>
> With this patch, we've just handed the user a way of spamming the logs
> at 1MHz.  This is bad.

Well there is WARN_ON_ONCE too to prevent that.

