Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1CIGns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:43:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43576 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1CIGnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:43:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 15:37:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmalloc: remove confusing comment on vwrite()
Message-Id: <20110309153715.153c524b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299652476-5185-1-git-send-email-namhyung@gmail.com>
References: <1299652476-5185-1-git-send-email-namhyung@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Mar 2011 15:34:36 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> KM_USER1 is never used for vwrite() path so the caller
> doesn't need to guarantee it is not used. Only the caller
> should guarantee is KM_USER0 and it is commented already.
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

