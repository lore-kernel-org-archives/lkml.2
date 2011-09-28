Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1I1GKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:10:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1I1GKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:10:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 15:09:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V10 6/6] mm: frontswap/cleancache: final
 flush->invalidate
Message-Id: <20110928150948.8071aa22.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110915213506.GA26426@ca-server1.us.oracle.com>
References: <20110915213506.GA26426@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 14:35:06 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V10 6/6] mm: frontswap/cleancache: final flush->invalidate
> 
> This sixth patch of six in this frontswap series completes the renaming
> from "flush" to "invalidate" across both tmem frontends (cleancache and
> frontswap) and both tmem backends (Xen and zcache), as required by akpm.
> This change is completely cosmetic.
> 
> [v10: no change]
> [v9: akpm@linux-foundation.org: change "flush" to "invalidate", part 3]
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

