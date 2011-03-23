Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1CWEkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:40:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43258 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1CWEkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:40:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Mar 2011 13:33:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused zone_idx variable from
 set_migratetype_isolate
Message-Id: <20110323133350.f6bbcebd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110322112647.GA5086@swordfish.minsk.epam.com>
References: <20110322112647.GA5086@swordfish.minsk.epam.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 13:26:47 +0200
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> mm: remove unused variable zone_idx and zone_idx call from set_migratetype_isolate
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

