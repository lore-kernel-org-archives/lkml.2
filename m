Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab2EPSTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:19:53 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45250 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759774Ab2EPSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:19:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KamoQ2IVM1np5rTORs3l3BJYSmTgbL.Jf1mUpjqufjFG4TI
 tn1w4w2_AsI4gbCdCA0Km_vsvNlGPg5.i1w7DY2lZGcqVqAkC5yLL0nznlDE
 7IOgVYKk3zU8Yo7N_W9_mC3XHjdISZRfRCtPbqNRxmY3hinHrsaVEtUqgZbq
 XbwsBMTDS0VtYuyvrTqpSM.rbeWLJsBQMmPunE4CLhZjpbrp2ITm_uRgNDVN
 JwFGT1F4yZf6l3KtyYN3xUu1L7lmTMyAV6_PqT_HiIKutAJDD7dEbp9XkxZH
 HseCjn.oHKhRjpha2d8hX1oe3RqYBQ_lO.6_xvoXPHq10ewGqbw2Ww1vEADV
 at4hmGMO13Wl3j22IHjcmhzkINGHWsJhk.J05kxDUUKQwiPHICEfAmrA9pVq
 Crq4Li0jxzCs6gSyTczd.YEPwkFsqYGC.z2yC8ZaF
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 16 May 2012 12:51:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pravin Shelar <pshelar@nicira.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jesse@nicira.com, abhide@nicira.com
Subject: Re: [PATCH v2] mm: Fix slab->page _count corruption.
In-Reply-To: <CALnjE+pbsS3W8G7yN82fdnchmXDxGkTo+Gy2b4kj6DkuQ=Z+wQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205161251001.25603@router.home>
References: <1337034597-1826-1-git-send-email-pshelar@nicira.com> <CALnjE+pbsS3W8G7yN82fdnchmXDxGkTo+Gy2b4kj6DkuQ=Z+wQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Pravin Shelar wrote:

> Can you comment on this patch. I have changed it according to your comments.

Looks fine to me.

Acked-by: Christoph Lameter <cl@linux.com>
