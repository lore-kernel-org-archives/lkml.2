Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1FHRd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:33:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46869 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1FHRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:33:26 -0400
Date: Wed, 8 Jun 2011 10:33:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, thomas@shipmail.org
Subject: Re: [PATCH] bugfix and cleanup patches in the TTM code for 3.1.
Message-Id: <20110608103308.483c41fe.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTikrO=skNyEcRsA7FKE+TGVwz7pXzQ@mail.gmail.com>
References: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
	<BANLkTikrO=skNyEcRsA7FKE+TGVwz7pXzQ@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DEFB262.002F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 19:30:22 +0200 Rafał Miłecki wrote:

> Hi Konrad,
> 
> 2011/6/8 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> > The bug-fix "ttm: Do not increment the amount of pages in a pool by the current amount"
> > I never observed, but found while looking at the code. The cleanup patch:
> > "ttm: Fix spelling mistakes and remove unused #ifdef", I had posted earlier and Randy
> > Dunlap graciously added some extra cleanups - which I have rolled in.
> 
> This is safe to put comments to the patch in the following place:
> 
> 
> Signed-off-by: (...)
> ---
> RIGHT HERE
> ---
>  drivers/(...)
> 
> 
> When applying such a patch comments will not be visible in git log.
> You may find this easier method of commenting your patches.

Yes, it would remove the temptation to make a patch 0/<small_number>
that several people are (sadly) using recently.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
