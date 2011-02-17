Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1BQPqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:46:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab1BQPqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:46:40 -0500
Date: Thu, 17 Feb 2011 16:46:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arvind R <arvino55@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37 2/4] edac: correct i82975x mci initialisation
In-Reply-To: <AANLkTimYvL7yn-X3ahUEt9EL4OVWQ=K-Spfc47qodh9J@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1102171646230.2160@pobox.suse.cz>
References: <AANLkTimYvL7yn-X3ahUEt9EL4OVWQ=K-Spfc47qodh9J@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Arvind R wrote:

> Subject: [PATCH 2.6.37 2/4] edac: correct i82975x mci initialisation
> 
> corrected mtype, and added dev_name,scrubmode initialisers
> in i82975x struct mem_ctl initialisation
> 
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  i82975x_edac.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
