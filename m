Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2CZXwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:52:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45573 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2CZXwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1203261346360.3443@eggly.anvils>
References: <1332777965-2534-1-git-send-email-consul.kautuk@gmail.com>
	<alpine.LSU.2.00.1203261346360.3443@eggly.anvils>
Date: Mon, 26 Mar 2012 19:52:17 -0400
Message-ID: <CAFPAmTQdud0rxbXt92zpRa+AmyNX8CKf=99X71VXvX9vteEC9g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap.c: find_vma: replace if(mm) check with BUG_ON(!mm)
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Thanks for the review.

I have sent another patch for this with changed subject and your changes.
