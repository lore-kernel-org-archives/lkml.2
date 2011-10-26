Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1JZTxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:53:21 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:38413 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1JZTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:53:19 -0400
Subject: Re: linux-next: Tree for Oct 25 (target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, target-devel@vger.kernel.org
In-Reply-To: <4EA853F2.4040503@xenotime.net>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
	 <4EA853F2.4040503@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 12:53:11 -0700
Message-ID: <1319658791.21607.5.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 11:39 -0700, Randy Dunlap wrote:
> On 10/25/11 02:36, Stephen Rothwell wrote:
> > Hi all,
> 
> target_core_cdb.c needs to include <linux/export.h>:
> 
> drivers/target/target_core_cdb.c:1316:1: warning: data definition has no type or storage class [enabled by default]
> drivers/target/target_core_cdb.c:1316:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> drivers/target/target_core_cdb.c:1316:1: warning: parameter names (without types) in function declaration [enabled by default]
> 
> 

This one had been addressed in target-pending.git/for-next with a
module.h include for target_core_cdb.c, but I'll change this now to use
the proper export.h.

Thanks Randy!

--nab

