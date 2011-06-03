Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1FCOGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:06:51 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25603 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754471Ab1FCOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:06:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .N1E0a8VM1mcQtt9credlIh1D52ZuaDuXe09xdDeIYpvxel
 9ktJcj_a3Nx5D5edFXhqi4jdPOC0xa7D_gFx3vTGFseVgcOqI3VXr__FUzbH
 JjwFlSV0NsVRAqbNgU6B72H_rTQITL5ND6miirOfL4YeqtEDVOvzF914J6O2
 S6D_0uOrbN01ulTWDemg0.MT8duaKiLNn4T.SZBU5Ptbb2YyiQ8E46YDOBeP
 eJH_ZVFCAvRZUvXtn0M4x_03Ow4AUoRmw9B8sgXa9Sv.UwFaLn0au6cUhfko
 uqBbBu.zLjOY5_APkJQ0T4si1EBoN2mbjX9PLVy7pu1hN4ymc
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Jun 2011 09:06:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Chris Metcalf <cmetcalf@tilera.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double
 requirement
In-Reply-To: <BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106030905590.27151@router.home>
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com> <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com> <4DE7D2AC.1070503@tilera.com> <BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1379602815-1307110008=:27151"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1379602815-1307110008=:27151
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 3 Jun 2011, Pekka Enberg wrote:

> > No, in 2.6.39 the irqsafe_cpu_cmpxchg_double() was guarded under "#ifde=
f
> > CONFIG_CMPXCHG_LOCAL". =A0Now it's not. =A0I suppose we could take the =
comment
> > change in percpu.h for 2.6.39, but it probably doesn't merit churning t=
he
> > stable tree.
>
> Yup. Looks good. Christoph?

Ok if we do not mind the packing density to be not that tight anymore.

Acked-by: Christoph Lameter <cl@linux.com>

---1463811839-1379602815-1307110008=:27151--
