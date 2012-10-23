Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2JWV64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:58:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2JWV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:58:54 -0400
Date: Tue, 23 Oct 2012 14:58:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-Id: <20121023145853.a9244066.akpm@linux-foundation.org>
In-Reply-To: <20121023213845.GA21115@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
	<20121023121005.ed33061a.akpm@linux-foundation.org>
	<20121023202612.GA20526@aftab.osrc.amd.com>
	<20121023133709.21e9cb72.akpm@linux-foundation.org>
	<20121023204926.GA20787@aftab.osrc.amd.com>
	<20121023140939.28ed0df4.akpm@linux-foundation.org>
	<20121023213845.GA21115@aftab.osrc.amd.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 23:38:45 +0200
Borislav Petkov <bp@amd64.org> wrote:

> And I see you'll carry this patch so I won't send it to Linus next merge
> window so thanks for this!

No, please merge it yourself.  Once it (or a version of it) turns up in
linux-next, I'll drop my copy.  Merging stuff I shouldn't is my crude
way of keeping track of things ;)


