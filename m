Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2BQP2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:28:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64378 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2BQP17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:27:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAFPAmTRrW4rAiC6UPGCFWChyuAjtbn7pkXRm3L2_SYdrRQCBZQ@mail.gmail.com>
References: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
	<1329491708.2293.277.camel@twins>
	<CAFPAmTRrW4rAiC6UPGCFWChyuAjtbn7pkXRm3L2_SYdrRQCBZQ@mail.gmail.com>
Date: Fri, 17 Feb 2012 10:27:59 -0500
Message-ID: <CAFPAmTRCoSqCVcN1ZnaWbKnadByEFkR17qH0wgmQQaoGv4K-Bw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rmap: Staticize page_referenced_file and page_referenced_anon
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I sent v2 of this anyway with the correct description.
