Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2AaJSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:18:00 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:44350 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab2AaJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:17:58 -0500
Message-ID: <1328001473.2297.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Vivek Goyal <vgoyal@redhat.com>, Wu Fengguang <wfg@linux.intel.com>
Date: Tue, 31 Jan 2012 10:17:53 +0100
In-Reply-To: <1328000036.21268.52.camel@sli10-conroe>
References: <1327996780.21268.42.camel@sli10-conroe>
	 <1327999722.2422.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1328000036.21268.52.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 janvier 2012 à 16:53 +0800, Shaohua Li a écrit :

> That added lines should not matter. We still need plug for direct-io
> case.
> Really sorry for this, I should ask you test it before adding the
> Tested-by.

No problem, but I prefer to test it in its final form before adding a TB

I did the test right now and everything seems fine to me, thanks !

Tested-by: Eric Dumazet <eric.dumazet@gmail.com>



