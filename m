Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2JPBy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:54:57 -0400
Received: from server505d.appriver.com ([98.129.35.42]:56633 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825Ab2JPByx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:54:53 -0400
X-Note-AR-ScanTimeLocal: 10/15/2012 8:54:52 PM
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
X-Note: Global Rule Hits: G321 G322 G323 G324 G328 G329 G340 G436 
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
Date: Mon, 15 Oct 2012 20:54:50 -0500
Subject: Re: [PATCH v4 05/24] block: Use bio_sectors() more consistently
Thread-Topic: [PATCH v4 05/24] block: Use bio_sectors() more consistently
Thread-Index: Ac2rQTsuf+lEV20iSUygN1G3DXNI2Q==
Message-ID: <FCC1E3FC-FE23-4BC7-A437-04471143D8B9@coraid.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-6-git-send-email-koverstreet@google.com>
In-Reply-To: <1350331769-14856-6-git-send-email-koverstreet@google.com>
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

The aoe changes look OK, thanks.

-- 
  Ed Cashin
  ecashin@coraid.com


