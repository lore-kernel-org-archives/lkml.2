Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1DDUq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:46:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1DDUqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:46:55 -0400
Subject: Re: mmotm 2011-03-31-14-48 uploaded
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110403181147.AE42.A69D9226@jp.fujitsu.com>
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>
	 <20110403181147.AE42.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Apr 2011 22:46:31 +0200
Message-ID: <1301949991.2221.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-03 at 18:11 +0900, KOSAKI Motohiro wrote:
> Ingo, Perter, Is this known issue?
> 
> 
> =======================================================================
> [    0.169037] divide error: 0000 [#1] SMP
> [    0.169982] last sysfs file:
> [    0.169982] CPU 0
> [    0.169982] Modules linked in:
> [    0.169982]
> [    0.169982] Pid: 1, comm: swapper Not tainted 2.6.39-rc1-mm1+ #2 FUJITSU-SV      PRIMERGY                      /D2559-A1
> [    0.169982] RIP: 0010:[<ffffffff8104ad4c>]  [<ffffffff8104ad4c>] find_busiest_group+0x38c/0xd30 

Not something I've recently seen, so no.
