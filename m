Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1FWRAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:00:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47428 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1FWRAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:00:18 -0400
Date: Thu, 23 Jun 2011 19:00:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tony.luck@intel.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
        rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110623170014.GN3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E035DD1.1030603@kpanic.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> According to Rick's reply in this thread a damaged row in a DIMM can
> easily cause a few thousand entries in the e820 table because it doesn't
> handle patterns. So the question I'm asking is, is it acceptable to
> have an e820 table with thousands maybe ten-thousands of entries?
> I really have no idea of the implications, maybe somebody else can
> comment on that.

I don't think it makes sense to handle something like that with a list.
The compact representation currently in badram is great for that.

-Andi
