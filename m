Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2KHTcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:32:51 -0500
Received: from server505e.appriver.com ([98.129.35.9]:3650 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756665Ab2KHTct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:32:49 -0500
X-Note-AR-ScanTimeLocal: 11/8/2012 1:32:47 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G329 G330 G331 G332 G336 G337 G348 G444 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Date: Thu, 8 Nov 2012 13:32:43 -0600
Subject: Re: [PATCH 1/8] aoe: avoid running request handler on plugged queue
Thread-Topic: [PATCH 1/8] aoe: avoid running request handler on plugged queue
Thread-Index: Ac2959LJjdJJMvdxSuWihBXxZauTaA==
Message-ID: <625E66C0-1433-48B5-84F1-B437DC9DACC9@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
 <20121108112625.2db76c8c.akpm@linux-foundation.org>
In-Reply-To: <20121108112625.2db76c8c.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2012, at 2:26 PM, Andrew Morton wrote:

> On Thu, 8 Nov 2012 11:29:32 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
> 
>> Signed-off-by: Ed Cashin <ecashin@coraid.com>
> 
> Could you please prepare decent changelogs for the patches?  Several of
> these appear to be bugfixes but we have no description of the
> user-visible behavioural changes.  So nobody knows what the patches do,
> nor which kernel version(s) they should be merged into.

Yes, sure.  For this one, I Cc'ed Jens Axboe in part because although I believe that it is correct to use __blk_run_queue rather than to call the request handler directly, I am going on old information.  I'm not entirely sure what the user impact is when the request hander is called directly, other than perhaps a slight performance hit.

But I'd like to do the right thing.  Jens Axboe, if you have a comment about correctness or user impact, I'd like to include that information in the changelog for this commit.  Or if the change doesn't look right to you, I'd like to know that.

Thanks.

-- 
  Ed Cashin
  ecashin@coraid.com


