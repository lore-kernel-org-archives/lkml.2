Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2BXXLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:11:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2BXXLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:11:31 -0500
Message-ID: <4F481921.9070609@suse.cz>
Date: Sat, 25 Feb 2012 00:11:29 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: semantic patch converting 0 test
 to null test
References: <1327696888-8186-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1327696888-8186-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.1.2012 21:41, Julia Lawall napsal(a):
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

I applied the whole series to kbuild.git#misc.

Michal

