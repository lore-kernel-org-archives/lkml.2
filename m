Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1DTOH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:07:57 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:28451 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752542Ab1DTOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:07:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: KP3JeLEVM1kb_2HiNZ_lVoN0AEIfYaPYvbkPZdDzlrE4J2X
 QfN2ZIZfdkdLE3nFliPAFqixogP5a1XIi1byTmUmDbO6AgAcu65qmFXX9u50
 0qCFHwR4d9MDp73JY3wQcKx0BbNQtrz38VGedXmpudhG4uPwX8dJARkM0gL6
 6QcwRP5CD29NImBgf7VK2MI0SE4IeDQDDyoyw_CNa1n.lD30CswinXU6EjHf
 4Rbp5_s1lYt.pIz8V9pz5eSvB7GoeL56f2qJ_KDAa91Rlv6A0YfhotRYoAH2
 BbC3qzXWd5thv.tY9IBNXnLdccUxGjZkXxhWUx84HzG_qVm4MUMn2PCfkgop
 4gPurIxNykmJaEzwvCHU7o.s-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Apr 2011 09:07:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1104200906170.8634@router.home>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Pekka Enberg wrote:

> That part makes me think the best option is to make parisc do
> CONFIG_NUMA as well regardless of the historical intent was.

Another possilibity is to use SPARSEMEM instead? We can do the same for
the other arches that we have done to x86.


