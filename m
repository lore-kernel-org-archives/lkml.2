Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0LFPyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:54:10 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36474 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753583Ab0LFPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:54:08 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 8A8nKOYVM1lawUGDLc7le_W2D50d.iaJm6DJ08qk5rGPUsx
 FCbpbxA88FkuClTlLvEN5tXxnJEk7MvwhuBCDIW34L7QZCzt9cWYe8pQwIN_
 XYpY4_EOUGNsYyYRURmo88inkiFAlIsS6hQ.0hOnCh42cCNIF9WZ_PFVKSKx
 ah6yXIGUe_a9HLZPEOvg4217hhuXhOw4em3LMOE.Cr5JhcLArgl45d_BnVRg
 5nseIETnpJHCHSrdT5uRx0HAazc8HSm3UOEkhdw--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 09:54:04 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rusty Russell <rusty@rustcorp.com.au>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 14/18] lguest: Use this_cpu_ops
In-Reply-To: <201012061816.07860.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.1012060952540.32000@router.home>
References: <20101130190707.457099608@linux.com> <20101130190849.422541374@linux.com> <201012061816.07860.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Rusty Russell wrote:

> This doesn't even compile :(

Yeah. I had to go through a lot of code and the build process did not
build all subsystem. Sorry.

> I've applied it, and applied the following fixes, too:

Great. Thanks.
