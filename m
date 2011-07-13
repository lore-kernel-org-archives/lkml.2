Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1GMXQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:16:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab1GMXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:16:45 -0400
Date: Wed, 13 Jul 2011 16:16:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Update $logFunctions
Message-Id: <20110713161640.83199c0b.akpm@linux-foundation.org>
In-Reply-To: <02ca5948a9627c6f4c2ab2b502f114623839c6fe.1310572985.git.joe@perches.com>
References: <02ca5948a9627c6f4c2ab2b502f114623839c6fe.1310572985.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 09:05:47 -0700
Joe Perches <joe@perches.com> wrote:

> Allow numbers in leading prefix.
> Add logging functions with _once and _ratelimit.
> Add <prefix>_printk.
> 

I look at this description wondering "hm, what does this do to
checkpatch behaviour" and realize I have not a clue.

Oh well, I'll trust you ;)

