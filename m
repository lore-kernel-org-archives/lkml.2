Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0I3IYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:24:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53676 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0I3IYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:22 -0400
Date: Thu, 30 Sep 2010 10:24:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, huang ying <huang.ying.caritas@gmail.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100930082418.GE21952@one.firstfloor.org>
References: <1285549026-5008-7-git-send-email-ying.huang@intel.com> <20100927104426.GD32222@erda.amd.com> <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com> <20100927134341.GQ13563@erda.amd.com> <20100927151607.GX26290@redhat.com> <1285633705.20791.84.camel@yhuang-dev> <20100928151924.GJ26290@redhat.com> <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com> <20100930040432.GD26290@redhat.com> <1285824074.6944.85.camel@yhuang-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285824074.6944.85.camel@yhuang-dev>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> die_chain is used for multiple purposes now.

Really should probably split it up. Having a fully separate notifier
for NMIs is very appropiate.

-Andi
