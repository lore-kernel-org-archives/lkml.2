Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1A1SrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:47:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab1A1SrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:47:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] signal: remove superflous try_to_freeze() loop in do_signal_stop()
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:37 +0100 <1296227324-25295-4-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-4-git-send-email-tj@kernel.org>
X-Shopping-List: (1) Monstrous glove auctions
   (2) Inauspicious flake inversions
   (3) Catalytic satanic confessions
   (4) Linty tape
Message-Id: <20110128184644.3B752180996@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 10:46:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
