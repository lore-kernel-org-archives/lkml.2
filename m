Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KZQhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:37:54 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:28797 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752372Ab0KZQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:37:54 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GYsx9ysVM1mgTWz14HHRFZa2SsxVanjiPZMxfwVxCRUH1by
 qRlQsavPkKhvc0ffxgJkdT1E639atTMO76Ura6rWe0TIb8NSVlO.OMgQFNre
 KnD_EXBcubPDjGVy0VD39nbsOn_ZrNm2K6_DXmDb8HRc0hJ97DBj4SRfesJi
 Xb4S8w9fmgw6.WBrdgkCyBOSh3FMob_S1r0dPGb_EDEn4VhU.WJePmgKICMN
 c0JRGrfFFH7JoYieLj48XM3i02njdBXCthRT9DA--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 10:37:49 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 03/10] percpu: Generic support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <4CEFE0E8.5050207@kernel.org>
Message-ID: <alpine.DEB.2.00.1011261036520.13524@router.home>
References: <20101123235139.908255844@linux.com> <20101123235157.644134695@linux.com> <4CEFE0E8.5050207@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Tejun Heo wrote:

> If we're gonna do __VA_ARGS__, can't we just replace
> __pcpu_size_call_return()?  Other than that, looks good to me.

A single parameter would require an empty vaarg list. All single parameter
invocations would have to specify an empty additional parameter.

