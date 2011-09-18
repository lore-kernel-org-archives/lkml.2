Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1IROlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 10:41:13 -0400
Received: from mta11.charter.net ([216.33.127.80]:52542 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1IROlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 10:41:12 -0400
X-Authority-Analysis: v=1.1 cv=L1BYdMBFPEvrb1U4o1gj35Y72n0OWZIL8AeNhXtfs6g=
 c=1 sm=1 a=gKDWx9ZG52YA:10 a=HmTQOF3YR7AA:10 a=jPJDawAOAc8A:10
 a=wPDyFdB5xvgA:10 a=IkcTkHD0fZMA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=-dj3fEGPH_kRry_Mh-YA:9 a=-ctVORmGu4cKgCSXVwsA:7 a=QEXdDO2ut3YA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 18 Sep 2011 09:41:07 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iwlegacy: change =?UTF-8?Q?IWL=5FWARN=20to=20IWL?=
 =?UTF-8?Q?=5FDEBUG=5FHT=20in=20iwl=34=39=36=35=5Ftx=5Fagg=5Fstart?=
In-Reply-To: <20110908161129.GC2195@redhat.com>
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110829122013.GA3597@redhat.com> <4E5B9533.6000109@cuw.edu>
 <20110829140032.GA1573@redhat.com> <20110906150131.GA7322@redhat.com>
 <4E683BBE.3060105@cuw.edu> <20110908161129.GC2195@redhat.com>
Message-ID: <06325e16d48ae62d4775167377ee7abe@farmergreg.com>
User-Agent: RoundCube Webmail/0.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 18:11:30 +0200, Stanislaw Gruszka wrote:

<snip>

> The second patch is ok. I'm not sure about first one, but we can get
> rid of "ctx = il_rxon_ctx_from_vif(vif)" at all, because we have
> only one context. Removing il_rxon_context structure from
> iwlegacy driver is my long term plan, you can look at that
> if you wish.
Sounds good. I'll let you know if I start to remove the il_rxon_context 
structure. It looks right now like I might not have much free time in 
the near future.

Greg
