Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1CHLSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:18:12 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:60322 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1CHLSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:18:11 -0500
Date: Tue, 8 Mar 2011 12:15:48 +0100
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
Message-ID: <20110308111548.GA6628@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 02:09:30PM +0000, Ivan Djelic wrote:
> Hello,
> 
> The first patch of this series contains a new generic BCH ECC library.

Hi,

It has been a month since this patch was posted, and I did not receive any
comment/review yet.

Could anyone give me any feedback, or maybe point me to people I should sent
the patch to ? A few MTD patches that I submitted depend on this library.

Also cc-ing Thomas Gleixner, as he is the author of the Reed-Solomon shared
library.

Thanks!

--
Ivan
