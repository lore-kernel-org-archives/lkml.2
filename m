Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0HBLeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab0HBLeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:34:13 -0400
Date: Mon, 2 Aug 2010 12:34:07 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Milan Broz <mbroz@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the device-mapper tree
Message-ID: <20100802113407.GF9734@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Milan Broz <mbroz@redhat.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100802113148.e0b70b34.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802113148.e0b70b34.sfr@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:31:48AM +1000, Stephen Rothwell wrote:
> I will use the device-mapper tree from next-20100730 for today.
 
Gah - I forgot to repush it, sorry.

Milan - I made it so the inner function always sets an error message, instead
of making the caller have a special case to detect whether or not it had been
set.

> P.S. the patch summaries could be more informative ... i.e. you should
> put "Subject:" lines in the patches.

They are the quilt filenames and the subject line gets generated automatically
from that when I import into git to submit to Linus.

Alasdair

