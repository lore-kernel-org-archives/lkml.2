Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0ESFiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:38:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52672 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0ESFiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100519152301.ad6cd9e9.sfr@canb.auug.org.au>
References: <20100519152301.ad6cd9e9.sfr@canb.auug.org.au>
Date: Tue, 18 May 2010 23:30:03 -0600
X-Google-Sender-Auth: vWO-5DBCEH5bOcbW6mbv0I3AmEY
Message-ID: <AANLkTikYNsOIXZFpqdTgFsTNkxc6xDuVOmnZJCrAw6jM@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the net tree
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@mvista.com>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 18, 2010, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> drivers/net/gianfar.c between commit
> b14ed884df5968b0977114ebd5a22f58d0d15315 ("gianfar: Remove legacy PM
> callbacks") from the net tree and commit
> 030d1870b731924034caf0c874981e2ed4f1becc ("drivers/net/of: don't use
> deprecated field in of_platform_driver") from the devicetree tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks right to me.  I'll probably wait until this and the other
conflicting trees are merged by Linus before I send him my pull
request so I can include the fixups.

Thanks,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
