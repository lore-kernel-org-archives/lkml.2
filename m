Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1GMCmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 22:42:18 -0400
Received: from mail.perches.com ([173.55.12.10]:3913 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175Ab1GMCmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 22:42:17 -0400
Subject: Re: [PATCH 3/3] coccicheck: add parallel execution
From: Joe Perches <joe@perches.com>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
In-Reply-To: <1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
	 <1310520405-1558-4-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 19:42:15 -0700
Message-ID: <1310524935.32558.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 20:26 -0500, Greg Dietsche wrote:
> For example to process 6 SmPL patches at the same time:
> 	make coccicheck PARALLEL=6
> Results are held in /tmp until the scripts finish. By doing this the
> script is able to collate the results from each SmPL patch instead of
> interleaving them in the output.

You might try adding support for gnu parallel instead.
http://www.gnu.org/software/parallel/


