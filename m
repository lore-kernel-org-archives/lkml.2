Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2JWKwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:52:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62202 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2JWKwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121023110434.021d100b@ilfaris>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
	<20121022173315.7b0da762@ilfaris>
	<20121022214502.0fde3adc@ilfaris>
	<20121022170452.cc8cc629.akpm@linux-foundation.org>
	<alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
	<20121023110434.021d100b@ilfaris>
Date: Tue, 23 Oct 2012 13:52:34 +0300
Message-ID: <CAJL_dMvUktOx9BqFm5jn2JbWbL_RWH412rdU+=rtDUvkuaPRUw@mail.gmail.com>
Subject: Re: Major performance regressions in 3.7rc1/2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Julian Wollrath <jwollrath@web.de>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the same problem.
Reverting
https://github.com/torvalds/linux/commit/957f822a0ab95e88b146638bad6209bbc315bedd
solves the problem for me.

Here is dmesg: http://pastebin.com/r78Rcrf5
