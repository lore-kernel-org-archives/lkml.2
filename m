Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1LMUNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:13:16 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:40738 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753301Ab1LMUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:13:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y88NLt8VM1lHB2vl6BSm1MYiIYvIwQSlvZUMgugfykwGqhG
 y1fF6liqfn6c7HhKaGa4VS9UVbyhcvrlgaZ11a3XaM_PX4UnJ.k7dWaDtnts
 8oz_P5BiSe8eppjC3qQp3ip_wmawBtTpv6D9zCd7w6Dk.jjqw.v5l3EYIaZE
 ddOurzHQoyEYtKUx2Hkd3UJZ_.aRvKfFIKrBLfAjw5_UVSu7R1_YdRW90EM4
 mR88OuT6FGAHP.RRvNX9w2QRKR6rve53FgBVwd.E5B3jPNFT28hX7LaT4XtG
 xedlygjNH_BvgjHUpXF4b.mQYnV3xXVCutdh1f66Y0EZFXmIaAQgN7kdmmRo
 VIe8Gp9hQbQii_Blj8.50aZyET7h4SpRtfpLiAamwk3C6N3pJPACUT3RoBCJ
 15R9SXPVNwIbBu754nHfKBQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 13 Dec 2011 14:12:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <ak@linux.intel.com>
cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, lee.schermerhorn@hp.com,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
In-Reply-To: <20111213190632.GA5830@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.00.1112131412320.27186@router.home>
References: <1323655125.22361.376.camel@sli10-conroe> <20111213190632.GA5830@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Andi Kleen wrote:

> I would prefer to add a new policy (INTERLEAVE_MULTI or so) for this
> instead of a global sysctl, that takes the additional parameter.

That would require a change of all scripts and code that uses
MPOL_INTERLEAVE. Lets not do that.

> Also I don't like having more per task state. Could you compute this
> from the address instead even for the process policy case?

That sounds good.

