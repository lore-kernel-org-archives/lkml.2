Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1FCOFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:05:12 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36027 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752086Ab1FCOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:05:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FdE5ve8VM1kGwhE4aJjWmenRP4a.t0e8C9_x_fr3Q7AXX0A
 PBJdFjL8qxILqijalHjCPdGcDUVm6GUi2oWANEHAtLDPhTAhnLpXUFkl2YbW
 Im_KAIpN3fSursMp8d9DWBCmHrBiu4Gx10QLTIYh5MZL7I7_M6NPYvsqv5Xs
 8HdykbZwKlD7rVf_CtsOR8cozWl4.MIQflQI4oHNPgCI0ck3wpRl6cyrbgzB
 xWx3DsN5O33YIhK9LkCB6lXKpEIfWsT_z1P5_q26LBt.eOWDfH89mbuzh3vT
 creBnP3h2IUsYgkiVTcvsY7O6GOCbiu.XE_kIN1Sa8ZsMTjNnz_AN4lx8eDI
 YA22Luu7sKStZV23i.GdJqmL2lQ--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Jun 2011 09:05:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Suleiman Souhlal <ssouhlal@freebsd.org>, penberg@kernel.org,
        suleiman@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mpm@selenic.com
Subject: Re: [PATCH] SLAB: Record actual last user of freed objects.
In-Reply-To: <alpine.DEB.2.00.1106021011510.18350@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1106030904320.27151@router.home>
References: <1306999002-29738-1-git-send-email-ssouhlal@FreeBSD.org> <alpine.DEB.2.00.1106021011510.18350@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, David Rientjes wrote:

> On Thu, 2 Jun 2011, Suleiman Souhlal wrote:
>
> > Currently, when using CONFIG_DEBUG_SLAB, we put in kfree() or
> > kmem_cache_free() as the last user of free objects, which is not
> > very useful, so change it to the caller of those functions instead.
> >
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>
> Acked-by: David Rientjes <rientjes@google.com>

Well note that this increases the overhead of a hot code path. But slub
does the same

Acked-by: Christoph Lameter <cl@linux.com>

