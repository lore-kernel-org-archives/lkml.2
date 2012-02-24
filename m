Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2BXOvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:51:21 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:50292 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2BXOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:51:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bsingharora@gmail.com designates 10.229.106.134 as permitted sender) smtp.mail=bsingharora@gmail.com; dkim=pass header.i=bsingharora@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1326912662-18805-1-git-send-email-asharma@fb.com>
	<CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
	<4F468888.9090702@fb.com>
	<20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 24 Feb 2012 20:21:18 +0530
Message-ID: <CAKTCnzk7TgDeYRZK0rCugopq0tO7BtM8jM9U0RJUTqNtz42ZKw@mail.gmail.com>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
From: Balbir Singh <bsingharora@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 8:17 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> They don't have access to each other's VMAs, but if "accidentally" one
>> of them comes across an uninitialized page with data from another task,
>> it's not a violation of the security model.

Can you expand more on the single address space model?

Balbir
