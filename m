Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0EFGXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:23:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42095 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFGXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:23:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 6 May 2010 15:18:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       akpm@linux-foundation.org, kirill@shutemov.name, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol - uninitialised return value
Message-Id: <20100506151858.cf3a5fe7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 14:21:49 +0300
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> Only an out of memory error will cause ret to be set.
> 
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

