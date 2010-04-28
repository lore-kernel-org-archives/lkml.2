Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0D1ODi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:03:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48327 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0D1ODh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:03:37 -0400
Subject: Re: [PATCH] Fix a huge latency problem in the MTD CFI and LPDDR
 flash drivers.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20100422230737.95e441ef.akpm@linux-foundation.org>
References: <1271623604.7050.0.camel@wall-e.seibold.net>
	 <1271787391.16051.4.camel@wall-e.seibold.net>
	 <1272002584.5347.2.camel@wall-e.seibold.net>
	 <20100422230737.95e441ef.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 16:58:16 +0300
Message-ID: <1272463096.7750.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Apr 2010 14:02:43.0502 (UTC) FILETIME=[78F4DCE0:01CAE6DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 23:07 -0400, Andrew Morton wrote:
> On Fri, 23 Apr 2010 08:03:04 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > David did not respond to my request since more than a month. Can u apply
> > the patch to linux next?
> 
> The patch is rather too fundamental for there to be benefit in me
> carrying it.
> 
> Hopefully Artem can look at it soon, although he's somewhat busy with
> real-life things at present.

Yeah, the patch is in my l2 tree, and David should take it to
mtd-2.6.git at some point, so it will probably be in 2.6.35, unless
David misses the merge window :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

