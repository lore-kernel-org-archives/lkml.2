Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0ICKE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:04:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0ICKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:04:57 -0400
Date: Fri, 3 Sep 2010 12:04:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: rdunlap@xenotime.net
Cc: "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
Message-ID: <20100903120449.3d177e04@basil.nowhere.org>
In-Reply-To: <41621.148.87.67.139.1283378664.squirrel@www.xenotime.net>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
	<41621.148.87.67.139.1283378664.squirrel@www.xenotime.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +int srat_bypass_bios = 0;
> 
> static int srat_bypass_bios;
> 
> Don't need to init to 0.

It actually doesn't matter to gcc, it generates the same
code for both cases.

-Andi
