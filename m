Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0IOPfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:35:19 -0400
Received: from mail.perches.com ([173.55.12.10]:2059 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0IOPfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:35:18 -0400
Subject: Re: [PATCH RFC v3] scripts/get_maintainer.pl: add interactive mode
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1284563819-11363-1-git-send-email-florian@mickler.org>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	 <1284563819-11363-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 08:35:15 -0700
Message-ID: <1284564915.1759.96.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 17:16 +0200, florian@mickler.org wrote:
> TODO:
>  Btw, --rolestats is somewhat broken in the current script, it assembles the statistics 
>  sequentially file by file, meaning that candidates that have only commits on the first 
>  file get a higher percentage as candidates also active on a later file...

Don't think so, statistics are assembled file by file and
the percentages are calculated the same way.

The output list is ordered by first file percentages though.


