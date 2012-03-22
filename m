Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2CVSYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2CVSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:24:10 -0400
Message-ID: <4F6B6DEA.3090408@redhat.com>
Date: Thu, 22 Mar 2012 14:22:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com>
In-Reply-To: <4F6B6BFF.1020701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 02:14 PM, Larry Woodman wrote:

> With this change we only migrate from nodes that are not in the
> destination nodesets:

That's a pretty obvious improvement :)

> Migrating 7 to 4
> Migrating 6 to 3
> Migrating 5 to 4
> Migrating 2 to 3
> Migrating 1 to 4
> Migrating 0 to 3
>
> Signed-off-by: Larry Woodman<lwoodman@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

