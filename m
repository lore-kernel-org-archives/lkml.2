Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1H2Hik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:38:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1H2Hif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:38:35 -0400
Date: Mon, 29 Aug 2011 09:38:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 10/16] freezer: fix set_freezable[_with_signal]() race
Message-ID: <20110829073828.GA18871@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-11-git-send-email-tj@kernel.org>
 <20110828180106.GC27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828180106.GC27032@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 08:01:06PM +0200, Oleg Nesterov wrote:
> You know, I was really, really puzzled by this change. Because it
> "obviously can fix nothing", and try_to_freeze() makes no sense
> (ignoring the very unlikely case when TIF_FREEZING was set right
> after we drop freezer_lock).
> 
> But I guess this works along with 14/16 which removes TIF_FREEZING.

Ah, yeah, another case of bad sequencing.  Sorry about that.

Thanks.

-- 
tejun
