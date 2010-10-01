Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074Ab0JABNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:13:35 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33403 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0JABNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:13:33 -0400
Date: Fri, 1 Oct 2010 10:07:39 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH v2] memcg: fix thresholds with use_hierarchy ==
 1
Message-Id: <20101001100739.0586cd14.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
References: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 13:16:32 +0300
"Kirill A. Shutsemov" <kirill@shutemov.name> wrote:

> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> We need to check parent's thresholds if parent has use_hierarchy == 1 to
> be sure that parent's threshold events will be triggered even if parent
> itself is not active (no MEM_CGROUP_EVENTS).
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
