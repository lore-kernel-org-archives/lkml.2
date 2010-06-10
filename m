Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0FJNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:14:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:53095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0FJNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:14:18 -0400
X-User-Agent: K-9 Mail for Android
In-Reply-To: <E1OMgIz-0005Wb-2a@pomaz-ex.szeredi.hu>
References: =?US-ASCII?Q?=3C20100601092456=2EGA23572=40alia?= =?US-ASCII?Q?=2Enute=2Enet=3E_=3C4C066CF4=2E2050902=40gm?= =?US-ASCII?Q?ail=2Ecom=3E=09=3C20100605085045=2EGA56?= =?US-ASCII?Q?30=40alia=2Enute=2Enet=3E_=3C4C0A1369=2E9010?= =?US-ASCII?Q?601=40kernel=2Eorg=3E_=3CE1OMICc-0005?= =?US-ASCII?Q?f8-G5=40pomaz-ex=2Eszeredi=2Ehu=3E_=3C4C1?= =?US-ASCII?Q?0CB39=2E70002=40kernel=2Eorg=3E_=3CE1OMg?= =?US-ASCII?Q?Iz-0005Wb-2a=40pomaz-ex=2Eszeredi=2Ehu=3E?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [fuse-devel] OSS Proxy Jack slave
From: Tejun Heo <tj@kernel.org>
Date: Thu, 10 Jun 2010 15:13:33 +0200
To: Miklos Szeredi <miklos@szeredi.hu>
CC: hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net, mszeredi@suse.cz,
       linux-kernel@vger.kernel.org
Message-ID: <869cdc8d-85cf-468e-8f94-ff50551684ba@email.android.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 13:13:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Nope, it's not required for osspd but it's a rather strong limitation on the interface which would be pretty difficult to work around later.  Page protection tricks would be very cumbersome and unscalable.  Hmmm, it does remove the necessity for allocating kernel pages, right?  Still, it seems like a big limitation.  Are you sure this is a good idea?

Thanks.

-- 
tejun
