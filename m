Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2IYAyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:54:11 -0400
Received: from server505k.appriver.com ([98.129.35.43]:59043 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919Ab2IYAyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:54:09 -0400
X-Note-AR-ScanTimeLocal: 9/24/2012 7:54:06 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
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
X-Note: Global Rule Hits: G317 G318 G319 G320 G324 G325 G336 G429 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Kent Overstreet <koverstreet@google.com>
CC: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "neilb@suse.de" <neilb@suse.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Alasdair Kergon <agk@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 24 Sep 2012 19:54:04 -0500
Subject: Re: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Thread-Topic: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Thread-Index: Ac2auELVtsNun8uOTpKcxXwmkaA6tA==
Message-ID: <084DC7FE-0C5B-45B4-8D8C-E4AFB7C555D1@coraid.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-8-git-send-email-koverstreet@google.com>
In-Reply-To: <1348526106-17074-8-git-send-email-koverstreet@google.com>
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

On Sep 24, 2012, at 6:34 PM, Kent Overstreet wrote:

> Bunch of places in the code weren't using it where they could be -
> this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> into a struct bvec_iter.

The aoe changes look fine to me, thanks.

-- 
  Ed Cashin
  ecashin@coraid.com	ecashin@noserose.net
  http://www.coraid.com	http://noserose.net/e/

