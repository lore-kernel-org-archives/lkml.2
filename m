Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1FHSVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:21:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43080 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1FHSVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:21:10 -0400
Date: Wed, 8 Jun 2011 14:20:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, thomas@shipmail.org
Subject: Re: [PATCH] bugfix and cleanup patches in the TTM code for 3.1.
Message-ID: <20110608182016.GA4582@dumpdata.com>
References: <1307552775-3185-1-git-send-email-konrad.wilk@oracle.com>
 <BANLkTikrO=skNyEcRsA7FKE+TGVwz7pXzQ@mail.gmail.com>
 <20110608103308.483c41fe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608103308.483c41fe.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DEFBD73.00CE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The bug-fix "ttm: Do not increment the amount of pages in a pool by the current amount"
> > > I never observed, but found while looking at the code. The cleanup patch:
> > > "ttm: Fix spelling mistakes and remove unused #ifdef", I had posted earlier and Randy
> > > Dunlap graciously added some extra cleanups - which I have rolled in.
> > 
> > This is safe to put comments to the patch in the following place:

Ok. Thanks will do.
