Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0IWHMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:12:03 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41697 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0IWHMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:12:01 -0400
Date: Thu, 23 Sep 2010 09:12:00 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] scripts/get_maintainer.pl: fix mailmap handling
Message-ID: <20100923091200.60ec30dc@schatten.dmk.lab>
In-Reply-To: <432055ff579ec701735c2cd1e0793b78000c90c6.1285209493.git.joe@perches.com>
References: <cover.1285209493.git.joe@perches.com>
	<432055ff579ec701735c2cd1e0793b78000c90c6.1285209493.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 19:50:13 -0700
Joe Perches <joe@perches.com> wrote:

> From: florian@mickler.org <florian@mickler.org>

Here again, my git-send-email borked it up: 

From: Florian Mickler <florian@mickler.org>

> 
> Implement it, like it is described in git-shortlog.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/get_maintainer.pl |  147 +++++++++++++++++++++++++++++++++------------
>  1 files changed, 109 insertions(+), 38 deletions(-)

Thx,
Flo
