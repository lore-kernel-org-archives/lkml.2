Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2GQWGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:06:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55362 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab2GQWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:06:39 -0400
Date: Tue, 17 Jul 2012 15:06:36 -0700 (PDT)
Message-Id: <20120717.150636.984057456046420738.davem@davemloft.net>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] sparc/ldc: remove IRQF_SAMPLE_RANDOM which is
 now a no-op
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342560756-18737-16-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
	<1342560756-18737-16-git-send-email-tytso@mit.edu>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 17 Jul 2012 17:32:34 -0400

> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Signed-off-by: David S. Miller <davem@davemloft.net>
