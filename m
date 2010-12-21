Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0LUWgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:36:06 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:24437 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753427Ab0LUWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:36:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: O.B6XUIVM1mWa_2UtAqIvFmi9ocz.Etpw1w4.6SoCMvY9PZ
 gUwYYkFJL5FfiW399kjETZw1P2zqY9oeOBCBXxmWkeSAAgXP3FGnCHWWXIWp
 gDtw_nccAgvgNC0bgXXykjNK7b82RvN5jHp2Ugjyizf10dxYKY02852ArE0R
 OQARcWZHX8B6r5r1XFvrgwuXcC.80lW335xbPx2WvUMnjsWHBLTglGh.4JFE
 _uCyw.W8VVFyf2Y.o9eCsQt.ZXeMWpWQH6C.DxvKbDHtSNO8HUwwvitpHXD4
 Dt_UHycBzv7PJgAjQGKqu17WUrz0pAOdEfph.SfOTcX6vkXk-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 21 Dec 2010 16:36:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <4D0CC982.3030905@kernel.org>
Message-ID: <alpine.DEB.2.00.1012211634560.3769@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010, Tejun Heo wrote:

> pointers from the beginning.  Anyways, that's too late, so is it
> completely impossible to make cmpxchg_double's take a scalar value?
> It can take the pointer all the same, no?

It could take a scalar value like the others but we are then not operating
on the scalar alone but also on the following field.

