Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0FAHVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:21:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FAHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:21:20 -0400
Date: Tue, 1 Jun 2010 09:21:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, mbroz@redhat.com,
       Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100601072115.GA30556@basil.fritz.box>
References: <4C040441.9020107@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C040441.9020107@wpkg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quite common to hit on a netbook/laptop with encrypted root these days, 
> where storage can be relatively fast when compared to the speed of one of 
> the cores of the (usually) multicore CPU.

My patch will help as long as the IO is submitted by multiple CPUs.
If that is not happening you would need pcrypt.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
