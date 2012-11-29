Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2K2Bee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:34:34 -0500
Received: from server505f.appriver.com ([98.129.35.10]:1953 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754631Ab2K2Bed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:34:33 -0500
X-Note-AR-ScanTimeLocal: 11/28/2012 7:34:31 PM
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
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Nov 2012 19:34:29 -0600
Subject: Re: [PATCH 0/8] aoe: miscellaneous fixes follow-up recent patch
 submissions
Thread-Topic: [PATCH 0/8] aoe: miscellaneous fixes follow-up recent patch
 submissions
Thread-Index: Ac3N0a0qT7gR/y3kRJSwIX1XAegbCQ==
Message-ID: <80039B9A-D6F1-4A48-B59D-2E231131A427@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
 <20121128154206.813a54f6.akpm@linux-foundation.org>
In-Reply-To: <20121128154206.813a54f6.akpm@linux-foundation.org>
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

On Nov 28, 2012, at 6:42 PM, Andrew Morton wrote:

> On Wed, 21 Nov 2012 19:52:41 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
> 
>> This patch series applies to today's linux-next/akpm, commit
>> d3faae60d84f586ff8937b77c8476bca1b5f8ec6.
>> 
>> Ed L. Cashin (8):
>>  aoe: copy fallback timing information on destination failover
>>  aoe: remove vestigial request queue allocation
>>  aoe: increase default cap on outstanding AoE commands in the network
>>  aoe: cleanup: correct comment for aoetgt nout
>>  aoe: remove call to request handler from I/O completion
>>  aoe: make error messages more specific in static minor allocation
>>  aoe: initialize sysminor to avoid compiler warning
>>  aoe: return real minor number for static minors
> 
> This series didn't contain your usual
> aoe-update-driver-internal-version-number-to-xx.patch


That's true, yes.  This was a bunch of fixups to 64+.  I suppose I could have called it "64+1" or something, but more patches are coming, so I wasn't sure it was worth it.

Thanks for mentioning it.

-- 
  Ed Cashin
  ecashin@coraid.com


