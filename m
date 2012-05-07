Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2EGR0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:26:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11542 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2EGR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:26:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 07 May 2012 10:25:44 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Mon, 7 May 2012 10:25:44 -0700
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Topic: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Index: Ac0q/p9y7Uj/UaDwQiK1WbQ4eKFk7QBd552g
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF106@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
	 <1336169422.16236.1.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
	 <1336170586.16236.11.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF103@HQMAIL04.nvidia.com>
 <1336250117.2463.140.camel@laptop>
In-Reply-To: <1336250117.2463.140.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q47HQKXg020186

>> >> Yes, this is for Nvidia's ARM Quad-core Tegra CPU. It is a single package, organized flatly.
>> Then you don't want to poke at SD_CPU_INIT since thats across packages.
Yes, I see that now.

I will rework the patch with guidance from other experts.

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Saturday, May 05, 2012 1:35 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'Andrew Morton'; 'Christoph Lameter'; 'Michael Neuling'; 'Stephen Rothwell'; 'Benjamin Herrenschmidt'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in sched domain

On Fri, 2012-05-04 at 16:18 -0700, Diwakar Tundlam wrote:

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
