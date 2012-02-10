Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2BJRpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:45:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39131 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751397Ab2BJRpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:45:46 -0500
Message-ID: <1328895943.14197.1.camel@joe2Laptop>
Subject: Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci: semantic patch
 for bool issues
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        bruce.w.allan@intel.com, rusty@rustcorp.com.au
Date: Fri, 10 Feb 2012 09:45:43 -0800
In-Reply-To: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks Julia.  It seems to work well.

Someone could run this with:

$ make coccicheck COCCI=scripts/coccinelle/misc/boolinit.cocci

