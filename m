Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1LZGmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:42:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51157 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1LZGmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:42:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 15:40:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/6] memcg: drop redundant brackets
Message-Id: <20111226154051.e0dad825.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1324695619-5537-6-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
	<1324695619-5537-6-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Dec 2011 05:00:19 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Maybe I tend to add too many braces at using macro.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

