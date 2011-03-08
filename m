Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1CHMke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:40:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1CHMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:40:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sIGgq8lro2UtzGgre4AOUdPjL7G21bjDh1h5E7ADiG/p0XFQFSPcxwyiKdRmd4X4oH
         5eir6XBN4sBZBHXzHK/hYbknFYrxSYTt20G038cW8q+yZhPPs3fvtG+JW3jsBZIVOgRR
         6O+22LHQacl8ZL3hdIipBiEtIbyFMweQzLbyE=
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110308111548.GA6628@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
	 <20110308111548.GA6628@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 14:39:05 +0200
Message-ID: <1299587945.2754.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 12:15 +0100, Ivan Djelic wrote:
> On Mon, Feb 07, 2011 at 02:09:30PM +0000, Ivan Djelic wrote:
> > Hello,
> > 
> > The first patch of this series contains a new generic BCH ECC library.
> 
> Hi,
> 
> It has been a month since this patch was posted, and I did not receive any
> comment/review yet.

I can add it to my l2 tree and may be dwmw2 can merge it then. But could
you please re-send a version with better Kconfig help messages?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

