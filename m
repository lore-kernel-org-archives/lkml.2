Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936007Ab2JYRgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:36:06 -0400
Received: from server505c.appriver.com ([98.129.35.7]:3992 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935904Ab2JYRgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:36:04 -0400
X-Note-AR-ScanTimeLocal: 10/25/2012 12:35:57 PM
X-Policy: GLOBAL - coraid.com
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
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G329 G330 G331 G332 G336 G337 G348 G444 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 12:35:54 -0500
Subject: Re: [PATCH] aoe: avoid using skb member after dev_queue_xmit
Thread-Topic: [PATCH] aoe: avoid using skb member after dev_queue_xmit
Thread-Index: Ac2y1y+KyT9E7InoQl2WPHSlUhPl+Q==
Message-ID: <4918A364-8C8A-4F69-B03F-644339FC1A7B@coraid.com>
References: <d1523cdc8a606d65418dc242e958ff1c@coraid.com>
 <20121024150807.82ce2677.akpm@linux-foundation.org>
 <20121025063322.GH20754@mwanda>
In-Reply-To: <20121025063322.GH20754@mwanda>
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

On Oct 25, 2012, at 2:33 AM, Dan Carpenter wrote:

> On Wed, Oct 24, 2012 at 03:08:07PM -0700, Andrew Morton wrote:
>> On Wed, 24 Oct 2012 14:26:13 -0400
>> Ed Cashin <ecashin@coraid.com> wrote:
>> 
>>> After calling dev_queue_xmit it is no longer safe to access the
>>> members of the skb.
>>> 
>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> 
>> hm, that was clever.  How did Dan detect this bug?
> 
> It was a Smatch thing, but it wasn't enabled by default.  I think I
> will enable it.  This is the second bug use after dev_queue_xmit()
> in two years.

OK, no more procrastinating.  I'm using smatch from today forward.

-- 
  Ed Cashin
  ecashin@coraid.com


