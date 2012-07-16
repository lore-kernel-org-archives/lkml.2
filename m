Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2GPHvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:51:44 -0400
Received: from ozlabs.org ([203.10.76.45]:55166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2GPHvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:51:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Shi <alex.shi@intel.com>, kosaki.motohiro@jp.fujitsu.com
Cc: alex.shi@intel.com, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpumask: cpumask_scnprintf() comments correction
In-Reply-To: <1342406154-24001-1-git-send-email-alex.shi@intel.com>
References: <1342406154-24001-1-git-send-email-alex.shi@intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 16 Jul 2012 17:10:09 +0930
Message-ID: <87ehocxig6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012 10:35:54 +0800, Alex Shi <alex.shi@intel.com> wrote:
> The function has no parameter @len now, so need to remove it from
> comments to avoid kernel-doc warning:

But it still does in my tree.

Please push this patch via whoever changed it?

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
