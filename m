Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2IKW2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:28:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2IKW2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:28:35 -0400
Date: Tue, 11 Sep 2012 15:28:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL] workqueue fixes for 3.6-rc5
Message-ID: <20120911222830.GJ7677@google.com>
References: <20120911222416.GI7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911222416.GI7677@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Forgot one thing.  There's another workqueue related regression which
reported a few days ago.

  https://bugzilla.kernel.org/show_bug.cgi?id=47301

It's a bit of head scratcher but there is a semi-reliable reproduce
case, so I'm hoping to resolve it soonish.

Thanks.

-- 
tejun
