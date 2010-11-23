Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0KWUQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:16:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab0KWUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:16:15 -0500
Date: Tue, 23 Nov 2010 12:16:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [BUG] memcg: fix false positive VM_BUG on non-SMP
Message-Id: <20101123121606.c07197e5.akpm@linux-foundation.org>
In-Reply-To: <1290520130-9990-1-git-send-email-kirill@shutemov.name>
References: <1290520130-9990-1-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 15:48:50 +0200
"Kirill A. Shutsemov" <kirill@shutemov.name> wrote:

> ------------[ cut here ]------------
> kernel BUG at mm/memcontrol.c:2155!

This bug has been there for a year, from which I conclude people don't
run memcg on uniprocessor machines a lot.

Which is a bit sad, really.  Small machines need resource control too,
perhaps more than large ones..
