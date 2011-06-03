Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1FCOli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:41:38 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:29986 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750705Ab1FCOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:41:37 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GhzxAM4VM1mDtSbkvMd8yLiUBBwdpioOZnei.rpkuBumqAw
 YWPW7jC05t7C.USWiVpySU6OVWSajrI11HBjfT6.JvihO_mcU7.Ljv9utdQf
 grMBBGU3yTcA8wojefEbGb53lXKx3Ko31yp.uIK60ATiW0BhSiJhtooHO3K7
 PMy8BGHANOCdDic3dmVWYqUllFr_Wqkpd_2TSNkaS7KWInfsvkGQ3rrkCoLp
 aTyfYUSJ_rCEFcL0oxgCjJbzwUuimUUNPaAyXb9PFNym5TMBSi1LKCQM9sPB
 B19rdG.XrS2uF_YEwe3Mgu7bGBNS5OLcESI2QrSXRbO1M_9CYQw--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Jun 2011 09:41:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double
 requirement
In-Reply-To: <4DE8F0D4.2090008@tilera.com>
Message-ID: <alpine.DEB.2.00.1106030941100.27151@router.home>
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com> <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com> <4DE7D2AC.1070503@tilera.com> <BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com> <alpine.DEB.2.00.1106030905590.27151@router.home>
 <4DE8F0D4.2090008@tilera.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011, Chris Metcalf wrote:

> On 6/3/2011 10:06 AM, Christoph Lameter wrote:
> > On Fri, 3 Jun 2011, Pekka Enberg wrote:
> >
> >> On Thu, Jun 2, 2011 at 9:13 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> >> > On 6/2/2011 1:16 PM, David Rientjes wrote:
> >> >> Acked-by: David Rientjes <rientjes@google.com>
> >> Yup. Looks good. Christoph?
> > Ok if we do not mind the packing density to be not that tight anymore.
> >
> > Acked-by: Christoph Lameter <cl@linux.com>
>
> I'm assuming from the acks that I should ask Linus to pull this for 3.0
> along with a couple of other minor tile-specific changes.  However, please
> let me know if someone else would rather take it into their tree instead --
> I don't want to step on any toes.  Thanks!

I would expect the patch to go through Pekka's tree to Linus.

