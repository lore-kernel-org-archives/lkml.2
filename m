Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0CaFsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:48:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1290 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab0CaFsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:48:21 -0400
Subject: Re: pr_* versus dev_*
From: Joe Perches <joe@perches.com>
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <u2y912ec82a1003302242sb4f1ac2arb9c464d35993b7a1@mail.gmail.com>
References: <912ec82a1003300907o7edeb73bp92d56741cfee1064@mail.gmail.com>
	 <1269967960.4558.162.camel@Joe-Laptop.home>
	 <u2y912ec82a1003302242sb4f1ac2arb9c464d35993b7a1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 22:48:19 -0700
Message-ID: <1270014499.14822.1.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 08:42 +0300, Neshama Parhoti wrote:
> so i should use whatever print call that adds most information right ?

I think so.

> even if that means that some part of the driver uses pr_* and some
> part of the driver use dev_* ?

Yes.

