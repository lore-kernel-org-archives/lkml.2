Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0EFGWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:22:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0EFGWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:22:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 6 May 2010 15:18:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       akpm@linux-foundation.org, kirill@shutemov.name, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: remove unnecessary use of atomic
Message-Id: <20100506151813.b4e625d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 14:21:48 +0300
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> The bottom 4 hunks are atomically changing memory to which there
> are no aliases as it's freshly allocated, so there's no need to
> use atomic operations.
> 
> The other hunks are just atomic_read and atomic_set, and do not
> involve any read-modify-write. The use of atomic_{read,set}
> doesn't prevent a read/write or write/write race, so if a race
> were possible (I'm not saying one is), then it would still be
> there even with atomic_set.
> 
> See:
> http://digitalvampire.org/blog/index.php/2007/05/13/atomic-cargo-cults/
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

