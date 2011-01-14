Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1ANMyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:54:35 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:41630 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab1ANMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:54:28 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
To: Nick Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
References: <7352.1294971049@jrobl> <AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com> <20110114052813.GZ19804@ZenIV.linux.org.uk> <AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
Date: Fri, 14 Jan 2011 21:54:23 +0900
Message-ID: <24273.1295009663@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> Yes I was completely wrong there, thanks again for another good
> catch. I'll merge this in the vfs-scale branch, and ask to merge if
> there are no objections.

I don't have any objection.

Thanks
J. R. Okajima
