Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1HWOba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:31:30 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:37853 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752254Ab1HWObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:31:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aNipPWQVM1kh0MdkI3ALkfe8NYv7ZWx_c3C6xMTc1pjAKYd
 R58s8d1kZod1HBA..Tokk.kbjvrcJG7L8pmU_LdVT4RSDskWQnfwCm3OQbQ7
 aCoIyAjatn2HjzYNFr_PpApegaA20EpWq_VnShYpsjpFvrr4.93lX6LbfsvH
 T1JRWeQEt6NLsWm1TPwwLy_QbrpP4GllVIQgcxi1TCIwOv_Lmj7F1PpA7UMS
 byDKaadyGfOpSx0BeNkdwDhK4aYpHCFRe5_HEGzOcExlstzZf.O3XlPIKwbt
 cU1GWSZRV4VLG0Ug5ah5Jq9X4r3wc_.gyLuGTlL8vMOINOwRFXJhaGk7G_72
 lGcpzfl.VHRHh_Ov.Y_YtLHGio4ifxUr0dONgf4UckpH.
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 23 Aug 2011 09:31:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joern Engel <joern@logfs.org>, logfs@logfs.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
In-Reply-To: <CAMuHMdVUvLAYpGDKsDUJ0DkLJEJKHCRy2Cj6miAH1YyEL6iWpw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108230931000.21267@router.home>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com> <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com> <CAMuHMdVUvLAYpGDKsDUJ0DkLJEJKHCRy2Cj6miAH1YyEL6iWpw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Geert Uytterhoeven wrote:

> On Mon, Aug 22, 2011 at 18:29, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > +/**
> > + * memchr_inv - Find a character in an area of memory.
>
> This description doesn't really match.

Seconded. If you fix that then

Acked-by: Christoph Lameter <cl@linux.com>

