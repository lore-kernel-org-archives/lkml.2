Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1BHF7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:59:13 -0500
Received: from lo.gmane.org ([80.91.229.12]:58132 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab1BHF7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:59:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: Regarding Buddy Allocator
Date: Tue, 8 Feb 2011 05:58:57 +0000 (UTC)
Message-ID: <iiqm31$3b5$1@dough.gmane.org>
References: <AANLkTinLOSfdO0HVABANiBnKgN540fc0pzqhjDAKAa2B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.102
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kernelnewbies@nl.linux.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Feb 2011 18:29:48 -0500, Sri Ram Vemulpali wrote:

> Can anyone point me to implementation of buddy allocator, with efficient
> data structures used. Thanks in advance.
> 
> I am trying to get another thought or implementation on code.

You need to check mm/page_alloc.c, especially __rmqueue_fallback()
and __free_one_page().

