Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2BHOpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:45:40 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20206 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754725Ab2BHOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:45:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CwbSfeYVM1mb.Kj.jV69vO9KAm_VESG4YhE0OVyh_hIWFeZ
 yHRarREomUYwJU1FRppowDX_W0rOWUrtFkfL_wLZlz6wAhQbUbck8EyLOI0d
 ydKzJ3cNUV8Pfah7xbLjJoFpa8a55URkFnJ5v.jkqcKYbkJEhklEnRU47MY7
 3xOO4T6KPKaOJiZGIxGJZzkItm4OYBzFfEivaVrD_gl7ACI8rCITFAPl9hYh
 1j88lth4cb.vYgglCXe1orjp3y21N3zs1y37hiqLb2JF4rvpaG4D8vpI71SU
 enKP7Dr.0G5MCSC6bxLV81tkxQXPAuwHadVQeYh5t16VJlPIjbOxKr3pxvSb
 mbugqD0ziMd1Yaxe_pRZ7KjRXpq2Ul6_sSrsulE.Yb2gSEe0.hs7XolUzFje
 ElXy54oYL9IHqsWm8X3mBO5TkkX94NB4M9R6f
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 8 Feb 2012 08:45:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        xiyou.wangcong@gmail.com, penberg@kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] selftests: Launch individual selftests from the main
 Makefile
In-Reply-To: <20120208034055.GA23894@somewhere.redhat.com>
Message-ID: <alpine.DEB.2.00.1202080843250.29839@router.home>
References: <20120205081555.GA2249@darkstar.redhat.com> <20120206155340.b9075240.akpm@linux-foundation.org> <20120208034055.GA23894@somewhere.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that slub also has an embedded selftest (see function
resiliency_test). That code could be separated out and put with the
selftests that you are creating now.

I also have a series of in kernel benchmarks for the page allocation, vm
statistics and slab allocators that could be useful to included somewhere.

All this code runs in the kernel context.

For the in kernel benchmarks I am creating modules that fail to load but
first run the tests.

