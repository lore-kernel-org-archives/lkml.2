Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1E2Sh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:37:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57526 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1E2Sh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GJ4ZIogWEaZe+V5hdRL8xOIfk8tOKtoVEVyvzOXd2nR60ClARWWX5PxDG6Sl8jAq4Z
         pT8bN8fwTv7T97FPdagzJv1kgz7GGdxrikvNyFlG9fsOLlIWaKv1qOLsxNePSDtG+obc
         NshjLBwwXwPGvzwVFwwIyl3O7xIxqzZk+AxwI=
MIME-Version: 1.0
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
Date: Mon, 30 May 2011 03:37:25 +0900
Message-ID: <BANLkTimxpFed3EO0qrKa8CfoJK=o0wjH8w@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Prevent LRU churning
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can see test script and all-at-once patch in following URL.
http://www.kernel.org/pub/linux/kernel/people/minchan/inorder_putback/v2/
-- 
Kind regards,
Minchan Kim
